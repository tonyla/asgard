module Asgard
  class Node
    include Asgard::Config::Loader

    attr_accessor :config, :prototype

    def initialize( config )
      self.config = config
      self.prototype = Prototype.new( config[:prototype] )
    end

    class << self
      def bootstrap( node_name )
        node = Asgard::Node.new(
          load_asgard_config( "nodes/#{node_name}.rb" )
        )
        ec2 = AWS::EC2.new
        puts node.prototype.config.inspect

        instance = ec2.instances.create(
          node.prototype.ec2.config
        )
        sleep 1 while instance.status == :pending
      end
    end

  end
end
