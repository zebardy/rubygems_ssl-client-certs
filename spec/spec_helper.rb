$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'rubygems'
require "rubygems_plugin"
