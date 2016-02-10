# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/rails/app/app_generator'
module Onotole
  class AppGenerator < Rails::Generators::AppGenerator
    def self.start
      class_option :database, type: :string, aliases: '-d', default: 'postgresql',
                              desc: "Configure for selected database (options: #{DATABASES.join('/')})"

      class_option :heroku, type: :boolean, aliases: '-H', default: false,
                            desc: 'Create staging and production Heroku apps'

      class_option :heroku_flags, type: :string, default: '',
                                  desc: 'Set extra Heroku flags'

      class_option :github, type: :string, aliases: '-G', default: nil,
                            desc: 'Create Github repository and add remote origin pointed to repo'

      class_option :skip_test_unit, type: :boolean, aliases: '-T', default: true,
                                    desc: 'Skip Test::Unit files'

      class_option :skip_turbolinks, type: :boolean, default: true,
                                     desc: 'Skip turbolinks gem'

      class_option :skip_bundle, type: :boolean, aliases: '-B', default: true,
                                 desc: "Don't run bundle install"

      class_option :user_gems, type: :boolean, aliases: '-c', default: false,
                               desc: 'Ask user for gem choice'

      class_option :clean_comments, type: :boolean, aliases: '--clean_comments', default: false,
                                    desc: 'Clean up comments in config & routes files'

      GEMPROCLIST.each do |g|
        class_option g.to_sym, type: :boolean, aliases: "--#{g}", default: false,
                               desc: "#{g.to_s.humanize} gem install"
      end
      super
    end

    def finish_template
      invoke :onotole_customization
      super
    end

    def onotole_customization
      invoke :customize_gemfile
      invoke :custom_gems_setup
      # invoke :bundler_stubs_install
      invoke :setup_git
      invoke :bundleinstall
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_production_environment
      invoke :setup_staging_environment
      invoke :setup_secret_token
      invoke :configure_app
      #  invoke :create_onotole_views
      #  invoke :setup_stylesheets
      #  invoke :install_bitters
      #  invoke :install_refills
      invoke :copy_miscellaneous_files
      invoke :customize_error_pages
      invoke :remove_config_comment_lines
      invoke :remove_routes_comment_lines
      invoke :setup_dotfiles
      invoke :post_init
      invoke :setup_gitignore
      invoke :setup_database
      invoke :create_heroku_apps
      invoke :create_github_repo
      invoke :setup_segment
      invoke :setup_spring
      invoke :git_first_commit
      invoke :outro
    end

    def customize_gemfile
      build :replace_gemfile
      build :set_ruby_to_version_being_used

      build :set_up_heroku_specific_gems if options[:heroku]
    end

    def custom_gems_setup
      if options[:user_gems]
        build :users_gems
      else
        build :user_gems_from_args_or_default_set
      end
    end

    def bundleinstall
      bundle_command 'install'
      build :install_user_gems_from_github
      build :configure_simple_form
    end

    def setup_database
      say 'Setting up database'

      build :use_postgres_config_template if 'postgresql' == options[:database]

      build :create_database
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_on_missing_assets_in_test
      build :raise_on_delivery_errors
      build :set_test_delivery_method
      build :raise_on_unpermitted_parameters
      build :provide_setup_script
      build :provide_dev_prime_task
      build :configure_generators
      build :configure_i18n_for_missing_translations
      build :configure_quiet_assets
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :set_up_factory_girl_for_rspec
      build :generate_factories_file
      #  build :set_up_hound
      build :generate_rspec
      build :configure_rspec
      build :configure_background_jobs_for_rspec
      build :enable_database_cleaner
      build :provide_shoulda_matchers_config
      build :configure_spec_support_features
      build :configure_ci
      build :configure_i18n_for_test_environment
      build :configure_action_mailer_in_specs
      build :configure_capybara_webkit
    end

    def setup_production_environment
      say 'Setting up the production environment'
      build :configure_newrelic
      build :configure_smtp
      build :configure_rack_timeout
      build :enable_rack_canonical_host
      build :enable_rack_deflater
      build :setup_asset_host
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def setup_secret_token
      say 'Moving secret token out of version control'
      build :setup_secret_token
    end

    # def create_onotole_views
    #   say 'Creating onotole views'
    #   build :create_partials_directory
    #   build :create_shared_flashes
    #   build :create_shared_javascripts
    #   build :create_application_layout
    # end

    def configure_app
      say 'Configuring app'
      build :configure_action_mailer
      build :configure_active_job
      build :configure_time_formats
      build :disable_xml_params
      build :fix_i18n_deprecation_warning
      build :setup_default_rake_task
      build :configure_puma
      build :set_up_forego
    end

    # def setup_stylesheets
    #   say 'Set up stylesheets'
    #   build :setup_stylesheets
    # end

    # def install_bitters
    #   say 'Install Bitters'
    #   build :install_bitters
    # end

    # def install_refills
    #   say "Install Refills"
    #   build :install_refills
    # end

    def setup_git
      unless options[:skip_git]
        say 'Initializing git'
        invoke :init_git
      end
    end

    def setup_gitignore
      unless options[:skip_git]
        say 'Replace .gitignore'
        invoke :setup_gitignore
      end
    end

    def git_first_commit
      invoke :git_init_commit unless options[:skip_git]
    end

    def create_heroku_apps
      if options[:heroku]
        say 'Creating Heroku apps'
        build :create_heroku_apps, options[:heroku_flags]
        build :provide_review_apps_setup_script
        build :set_heroku_serve_static_files
        build :set_heroku_remotes
        build :set_heroku_rails_secrets
        build :create_heroku_pipelines_config_file
        build :create_heroku_pipeline
        build :provide_deploy_script
        build :configure_automatic_deployment
      end
    end

    def create_github_repo
      if !options[:skip_git] && options[:github]
        say 'Creating Github repo'
        build :create_github_repo, options[:github]
      end
    end

    def setup_segment
      say 'Setting up Segment'
      build :setup_segment
    end

    def setup_dotfiles
      build :copy_dotfiles
    end

    def setup_gitignore
      build :gitignore_files
    end

    def git_init_commit
      build :git_init_commit
    end

    def setup_spring
      say 'Springifying binstubs'
      build :setup_spring
    end

    def init_git
      build :init_git
    end

    # def bundler_stubs_install
    #   say 'Bundler stubs install'
    #   build :rvm_bundler_stubs_install
    # end

    def copy_miscellaneous_files
      say 'Copying miscellaneous support files'
      build :copy_miscellaneous_files
    end

    def customize_error_pages
      say 'Customizing the 500/404/422 pages'
      build :customize_error_pages
    end

    def remove_config_comment_lines
      build :remove_config_comment_lines if options[:clean_comments] == true
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines if options[:clean_comments] == true
    end

    def outro
      build :show_goodbye_message
    end

    def post_init
      build :post_init
      build :add_bullet_gem_configuration
    end

    protected

      def get_builder_class
        Onotole::AppBuilder
      end

      def using_active_record?
        !options[:skip_active_record]
      end
  end
end
