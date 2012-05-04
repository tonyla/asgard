require 'rubygems'
require 'thor'
require File.dirname(__FILE__)
module Asgard
  class CLI < Thor

    desc "bootstrap [NODE_NAME]", "bootstrap and provision node"
    def bootstrap( node_name )
      Asgard::Node.bootstrap( node_name )
    end

  end
end
