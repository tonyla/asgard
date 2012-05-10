module Asgard
  class Node
    include Asgard::Config::Loader

    attr_accessor :config, :platform, :run_list, :name

    def initialize( node_name )
      @name = node_name
      @run_list = []
      @config = load_config
      @platform = Platform.create_from_config( @name, config[:platform] )
    end


    def load_config
      # load node config
      node_file = "nodes/#{@name}.rb"
      raise RuntimeError.new( "Node file does not exist: #{node_file}" ) if !File.exists?( node_file )
      node_config = load_asgard_config( node_file )

      # load environment config and override
      env_name = node_config[:environment]
      environment_config = load_asgard_config( "environments/#{env_name}.rb" )
      node_config[:sprinkle].deep_merge!( environment_config )

      # load config for roles
      node_config[:roles].each do |role|
        role_config = load_asgard_config( "roles/#{role}.rb" )
        @run_list.concat( role_config[:run_list] )
        node_config[:sprinkle].deep_merge!( role_config[:sprinkle] ) if role_config[:sprinkle]
      end
      node_config
    end

    def bootstrap
      ec2 = AWS::EC2.new

      instance = ec2.instances.create(
        prototype.ec2.config
      )

      instance.add_tag( 'Name', :value => @name )
      instance.add_tag( ec2_identifer )
      sleep 1 while instance.status == :pending
    end

    def sprinkle
      powder = Sprinkle::Script.new

      plat = @platform

      # Load configurations
      Configurator.instance.apply_config( @config )
      rl = @run_list
      powder.instance_eval do

        # Load sprinkle packages
        Dir.glob( 'sprinkle/packages/*.rb') do |package|
          require "#{Dir.pwd}/#{package}"
        end

        # Load sprinkle meta packages
        Dir.glob( 'sprinkle/meta_packages/*.rb') do |package|
          require "#{Dir.pwd}/#{package}"
        end

        # Load sprinkle policies
        #Dir.glob( 'sprinkle/policies/*.rb') do |policy|
          #require "#{Dir.pwd}/#{policy}"
        #end

        policy :asgard, :roles => :app do
          rl.each do |r|
            requires r
          end
        end

        deployment do

          delivery :capistrano do
            role :app, plat.url
            set  :user, Asgard::Config.instance['cap']['user']
            set  :use_sudo, false
            ssh_options[:keys] = Asgard::Config.instance['cap']['ssh_options']['keys']
            set  :run_method, :run
            default_run_options[:pty] = true
            default_run_options[:shell] = false # use false to NOT use a sub-shell, which helps with a lot of things
            set :default_environment, Asgard::Config.instance['cap']['default_environment']
          end

          source do
            prefix   '/usr/local'
            archives '/usr/local/sources'
            builds   '/usr/local/build'
          end
        end
      powder.sprinkle
    end
  end

  end
end
