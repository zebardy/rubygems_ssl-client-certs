require 'spec_helper'

describe Gem::ConfigFile do

  def gemrc_location
    File.dirname(__FILE__) + '/fixtures/gemrc'
  end

  describe ".new" do
    it "initializes ssl vars" do
      config = Gem::ConfigFile.new( [ "--config-file", gemrc_location ] )
      config.ssl_verify_mode.should eq("bob")
      config.ssl_ca_cert.should eq("steve")
      config.ssl_client_cert.should eq("dave")
    end
    it "original initialize is still called" do
      #Test by setting the backtrace value which defaults to false
      config = Gem::ConfigFile.new( [ "--backtrace" ] )
      config.backtrace.should be_true
    end
  end
end
