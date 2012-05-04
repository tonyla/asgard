require 'active_support'
require 'active_support/hash_with_indifferent_access'
require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

require "aws-sdk"

module Asgard
  # Your code goes here...
end
Asgard::Config.load_config!
