require 'yaml'

module Asgard
  class Config

    class << self
      def load_config!
        config = YAML.load( File.open( 'config/aws.yml' ) )

        AWS.config(
          access_key_id: config['aws']['access_key_id'],
          secret_access_key: config['aws']['secret_access_key']
        )
      end
    end

  end
end
