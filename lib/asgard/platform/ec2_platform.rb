module Asgard
  module Platform

    class EC2Platform < Base

      def public_dns
        server.dns_name
      end

      def private_dns
        server.private_dns_name
      end

      def bootstrap
        raise RuntimeError.new( "Instance #{@node_name} exists!" ) if exists?
        instance = ec2.instances.create( @config[:ec2] )

        instance.add_tag( 'Name', :value => @node_name )
        instance.add_tag( ec2_identifer )
        sleep 1 while instance.status == :pending
        volumes = @config[:volumes] || []
        volumes.each do |volume|
          v = ec2.volumes.create( volume[:volume] )
          attachment = v.attach_to( instance, volume[:mount] )
          v.add_tag( 'Name', :value => @node_name )
          v.add_tag( ec2_identifer )
          sleep 1 until attachment.status != :attaching
        end
        instance
      end

      def delete
        raise RuntimeError.new( "Instance #{@node_name} does not exist!" ) if !exists?
        ec2.volumes.tagged( ec2_identifer ).each{ |v| v.delete }
        server.delete
      end

      def process_environment
        @config[:environment].each do |key, value|
          send( key, value )
        end
      end

      def elastic_ip
      end

      def exists?
        !(server.nil?)
      end

      private

      def ec2
        @ec2 ||= AWS::EC2.new
      end

      def ec2_identifer
        "asgard_#{@node_name}"
      end

      def server
        @server ||= ec2.instances
                      .tagged( ec2_identifer )
                      .select{ |i| i if i.exists? && i.status == :running }
                      .first
      end
    end

  end
end
