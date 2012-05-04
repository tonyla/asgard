module Asgard
  class Node

    class << self
      def bootstrap( node_name )
        node = Thor::Node.new( instance_eval( File.open( "nodes/#{node_name}.rb" ) ) )
      end
    end

  end
end
