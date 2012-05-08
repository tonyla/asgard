require 'active_support'
require 'active_support/all'
require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

require "aws-sdk"
require "sprinkle"

module Asgard
  # Your code goes here...
end
Asgard::Config.load_config!

require 'asgard/sprinkle/configurator'
class Object
  include Sprinkle::Configurator
end
