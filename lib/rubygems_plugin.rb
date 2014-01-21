require 'rubygems/remote_fetcher'

class Gem::ConfigFile

  attr_reader :ssl_client_cert

  attr_reader :ssl_verify_mode

  attr_reader :ssl_ca_cert

  class << self
    unless self.method_defined? :__new__
      alias_method :__new__, :new
    end

    def new(*args)
      puts "setting up constructor"
      config = __new__(*args)
      config.set_ssl_vars
      return config
    end

  end

  def set_ssl_vars
    puts "iinitializing ssl vars"
    @ssl_verify_mode = @hash[:ssl_verify_mode] if @hash.key? :ssl_verify_mode
    @ssl_ca_cert = @hash[:ssl_ca_cert] if @hash.key? :ssl_ca_cert
    @ssl_ca_cert = ENV['BUNDLE_SSL_CA_CERT'] unless @ssl_ca_cert
    @ssl_client_cert = @hash[:ssl_client_cert] if @hash.key? :ssl_client_cert
    @ssl_client_cert = ENV['BUNDLE_SSL_CLIENT_CERT'] unless @ssl_client_cert
  end

  if Gem.instance_variable_get(:@configuration) then
    Gem.configuration = nil
  end

end

if Gem::Version.new(Gem::VERSION) < Gem::Version.new('2.1.0') then

  class Gem::RemoteFetcher

    unless Gem::RemoteFetcher.respond_to? "no_proxy?" then
      def no_proxy? host
        host = host.downcase
        get_no_proxy_from_env.each do |pattern|
          pattern = pattern.downcase
          return true if host[-pattern.length, pattern.length ] == pattern
        end
        return false
      end
    end

    def connection_for(uri)
      net_http_args = [uri.host, uri.port]
      puts "running patched connection_for"

      if @proxy_uri and not no_proxy?(uri.host) then
        net_http_args += [
          @proxy_uri.host,
          @proxy_uri.port,
          @proxy_uri.user,
          @proxy_uri.password
        ]
      end

      connection_id = [Thread.current.object_id, *net_http_args].join ':'
      @connections[connection_id] ||= Net::HTTP.new(*net_http_args)
      connection = @connections[connection_id]

      if https?(uri) and not connection.started? then
        configure_connection_for_https(connection)
      end

      connection.start unless connection.started?

      connection
    rescue defined?(OpenSSL::SSL) ? OpenSSL::SSL::SSLError : Errno::EHOSTDOWN,
           Errno::EHOSTDOWN => e
      raise FetchError.new(e.message, uri)
    end

    def configure_connection_for_https(connection)
      require 'net/https'
      connection.use_ssl = true
      connection.verify_mode =
        Gem.configuration.ssl_verify_mode || OpenSSL::SSL::VERIFY_PEER
      store = OpenSSL::X509::Store.new

      if Gem.configuration.ssl_client_cert
        puts "configuring client ssl cert"
        pem = File.read(Gem.configuration.ssl_client_cert)
        connection.cert = OpenSSL::X509::Certificate.new(pem)
        connection.key = OpenSSL::PKey::RSA.new(pem)
      else
        puts "no client cert given"
      end

      store.set_default_paths
      add_rubygems_trusted_certs(store)
      if Gem.configuration.ssl_ca_cert
        puts "configuring ca certs"
        if File.directory? Gem.configuration.ssl_ca_cert
          store.add_path Gem.configuration.ssl_ca_cert
        else
          store.add_file Gem.configuration.ssl_ca_cert
        end
      else
        puts "using default ca certs"
      end
      connection.cert_store = store
    rescue LoadError => e
      raise unless (e.respond_to?(:path) && e.path == 'openssl') ||
                   e.message =~ / -- openssl$/

      raise Gem::Exception.new(
              'Unable to require openssl, install OpenSSL and rebuild ruby (preferred) or use non-HTTPS sources')
    end

    def add_rubygems_trusted_certs(store)
      pattern = File.expand_path("./ssl_certs/*.pem", File.dirname(__FILE__))
      Dir.glob(pattern).each do |ssl_cert_file|
        store.add_file ssl_cert_file
      end
    end

    def https?(uri)
      uri.scheme.downcase == 'https'
    end

  end
end
