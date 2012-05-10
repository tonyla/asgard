module Asgard
  module Platform

    class EC2Platform < Base

      def url
        server.ip_address
      end

      private
      def ec2_identifer
        "asgard_#{@node_name}"
      end

      def server
        ec2 = AWS::EC2.new
        @server ||= ec2.instances.tagged( ec2_identifer ).first
      end
    end

  end
end
