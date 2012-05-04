module Asgard
  class Config

    module Loader

      def self.included(base)
        base.send :extend, LoaderMethods
        base.send :include, LoaderMethods
      end

      module LoaderMethods
        def load_asgard_config( path )
          instance_eval( File.open( path ).read )
        end
      end

    end

  end
end
