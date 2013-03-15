module Asgard
  class Node
    include Asgard::Config::Loader

    attr_accessor :config, :environment, :platform, :run_list, :name

    def initialize( node_name )
      @name = node_name
      @run_list = []
      @config = load_config
      @platform = Platform.create_from_config( @name, config[:platform] )
      puts @platform.config.inspect
      @environment = @config[:environment]
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
      @platform.bootstrap
    end

    def delete
      @platform.delete
    end

    def sprinkle
      powder = Sprinkle::Script.new

      plat = @platform
      raise RuntimeError.new( "Instance #{@name} does not exist!" ) if !plat.exists?

      # Load configurations
      Configurator.instance.setup( @config, self )
      rl = @run_list
      powder.instance_eval do

        # Load sprinkle packages
        Dir.glob( 'sprinkle/packages/*.rb') do |package|
          begin
            require "#{Dir.pwd}/#{package}"
            puts "Loaded package: #{package}"
          rescue => e
          end
        end

        # Load sprinkle meta packages
        Dir.glob( 'sprinkle/meta_packages/*.rb') do |package|
          begin
          require "#{Dir.pwd}/#{package}"
          puts "Loaded meta package: #{package}"
          rescue => e
          end
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
            role :app, plat.public_dns
            set  :user, plat.config[:cap][:user]
            set  :use_sudo, false
            ssh_options[:keys] = plat.config[:cap][:ssh_options][:keys] if plat.config[:cap][:ssh_options] && plat.config[:cap][:ssh_options][:keys]
            set :password, plat.config[:cap][:password] if plat.config[:cap][:password]
            set  :run_method, :run
            default_run_options[:pty] = true
            default_run_options[:shell] = false # use false to NOT use a sub-shell, which helps with a lot of things
            set :default_environment, plat.config[:cap][:default_environment] if plat.config[:cap][:default_environment]
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
