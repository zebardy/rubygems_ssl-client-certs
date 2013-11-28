require "spec_helper"

describe Gem do

  def create_gem()
    gem = subject
    return gem
  end

  def plugin_location
    File.dirname(__FILE__) + '/../../lib/rubygems_plugin.rb'
  end

  def gemrc_location
    File.dirname(__FILE__) + '/../fixtures/gemrc'
  end

  describe "load_env_plugins" do
    it "successfully loads the ssl client cert plugin" do
      gem = create_gem()
      plugins = [ plugin_location ]
      gem.load_plugin_files(plugins)
      Gem::ConfigFile.new( [ "--config-file", gemrc_location ] )
    end
  end

end
