require 'spec_helper'
require 'uri'

describe Gem::RemoteFetcher do

  def create_fetcher()
    fetcher = subject
    return fetcher
  end

  describe "#https?" do
    it "returns true when protocol is https" do
      fetcher = create_fetcher()
      fetcher.https?(URI("https://www.example.com")).should be_true
    end

    it "returns false when protocol is http" do
      fetcher = create_fetcher()
      fetcher.https?(URI("http://www.example.com")).should be_false
    end
  end

  describe "#configure_connection_for_https" do
    it "configures ssl settings on the connection" do
      fetcher = create_fetcher()
      connection =  #mock Net::HTTP object
      fetcher.configure_connection_for_https(connection)
    end
  end

end
