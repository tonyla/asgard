require 'rubygems'
require 'thor'
require File.dirname(__FILE__)
module Asgard
  class CLI < Thor

    desc "create [NODE_NAME]", "create EC2 instance for node"
    def create( node_name )
      node = Asgard::Node.new( node_name )
      node.bootstrap
    end

    desc "provision [NODE_NAME]", "Use sprinkle to provision a node"
    def provision( node_name)
      node = Asgard::Node.new( node_name )
      node.sprinkle
    end

  end
end
