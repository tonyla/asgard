require 'rubygems'
require 'thor'
require File.dirname(__FILE__)
module Asgard
  class CLI < Thor

    desc "bootstrap [NODE_NAME]", "bootstrap and provision node"
    def bootstrap( node_name )
      node = Asgard::Node.new( node_name)
      puts node.config.inspect
      #node.bootstrap( node_name )
      node.sprinkle
    end

  end
end
