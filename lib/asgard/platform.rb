module Asgard
  module Platform
    include Asgard::Config::Loader

    def self.create_from_config( node_name, name )
      Asgard::Config.load_config!
      config = load_asgard_config( "platform/#{name}.rb" )
      case config[:type]
      when 'ec2'
        EC2Platform.new( node_name, config[:platform] )
      when 'vps'
      end
    end

  end
end
