module Asgard
  module Platform
    include Asgard::Config::Loader

    def self.create_from_config( node_name, node_config )
      name = node_config.delete(:name)
      config = load_asgard_config( "platform/#{name}.rb" )
      node_config.deep_merge!(config[:platform])
      case config[:type]
      when 'ec2'
        EC2Platform.new( node_name, node_config)
      when 'vps'
        VpsPlatform.new( node_name, node_config )
      end
    end

  end
end
