require 'active_support'
require 'active_support/dependencies'
require 'active_support/core_ext/hash/deep_merge'
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

require "aws-sdk"
require "sprinkle"

module Asgard
  # Your code goes here...
end

require 'asgard/sprinkle/configurator'
class Object
  include Sprinkle::Configurator
end
