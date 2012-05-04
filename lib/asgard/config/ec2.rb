module Asgard
  class Config
    class EC2

      attr_accessor :config
      def initialize( config )
        self.config = config
      end

    end
  end
end
