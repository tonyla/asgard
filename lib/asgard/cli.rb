require 'rubygems'
require 'thor'
require File.dirname(__FILE__)
module Asgard
  class CLI < Thor

    desc "new project [PROJECT_NAME]", "create new Asgard project"
    def new( project_name )
      Asgard::Project.start [project_name]
    end

    desc "create [NODE_NAME]", "create EC2 instance for node"
    def create( node_name )
      node = Asgard::Node.new( node_name )
      node.bootstrap
    end

    desc "delete [NODE_NAME]", "delete EC2 instance for node"
    def delete( node_name )
      node = Asgard::Node.new( node_name )
      node.delete
    end

    desc "provision [NODE_NAME]", "Use sprinkle to provision a node"
    def provision( node_name)
      node = Asgard::Node.new( node_name )
      node.sprinkle
    end

    desc "ssh into [NODE_NAME]", "Use sprinkle to ssh via node name"
    def info( node_name )
      node = Asgard::Node.new( node_name )
      puts "public_dns: #{node.platform.public_dns}"
    end

  end
end
