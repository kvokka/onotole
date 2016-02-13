# frozen_string_literal: true
require 'forwardable'
# require 'pry'
Dir['lib/onotole/**/*.rb'].each { |file| require file.slice(4..-4) }

module Onotole
  class AppBuilder < Rails::AppBuilder
    include Onotole::Actions
    include Onotole::UserGemsMenu
    include Onotole::EditMenuQuestions
    include Onotole::BeforeBundlePatch
    include Onotole::AfterInstallPatch
    include Onotole::Helpers
    include Onotole::Git
    include Onotole::Tests
    include Onotole::Mail
    include Onotole::Goodbye
    include Onotole::FrontendDefault
    extend Forwardable

    @use_asset_pipelline = true
    @user_choice = []
    @app_file_scss = 'app/assets/stylesheets/application.scss'
    @app_file_css = 'app/assets/stylesheets/application.css'
    @js_file = 'app/assets/javascripts/application.js'

    class << self
       attr_accessor :use_asset_pipelline,
                     :devise_model,
                     :user_choice, :app_file_scss, :app_file_css, :js_file
    end

    def_delegators :heroku_adapter,
                   :create_heroku_pipelines_config_file,
                   :create_heroku_pipeline,
                   :create_production_heroku_app,
                   :create_staging_heroku_app,
                   :provide_review_apps_setup_script,
                   :set_heroku_rails_secrets,
                   :set_heroku_remotes,
                   :set_heroku_serve_static_files,
                   :set_up_heroku_specific_gems

    def readme
      template 'README.md.erb', 'README.md'
    end

    def add_bullet_gem_configuration
      config = <<-RUBY
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end

      RUBY

      inject_into_file(
        'config/environments/development.rb',
        config,
        after: "config.action_mailer.raise_delivery_errors = true\n"
      )
    end

    def raise_on_unpermitted_parameters
      config = "\n    config.action_controller.action_on_unpermitted_parameters = :raise\n"
      inject_into_class 'config/application.rb', 'Application', config
    end

    def provide_setup_script
      template 'bin_setup', 'bin/setup', force: true
      run 'chmod a+x bin/setup'
    end

    def provide_dev_prime_task
      copy_file 'dev.rake', 'lib/tasks/dev.rake'
    end

    def set_up_hound
      copy_file 'hound.yml', '.hound.yml'
    end

    def configure_newrelic
      template 'newrelic.yml.erb', 'config/newrelic.yml'
    end

    def enable_rack_canonical_host
      config = <<-RUBY

  if ENV.fetch("HEROKU_APP_NAME", "").include?("staging-pr-")
    ENV["APPLICATION_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
  end

  # Ensure requests are only served from one, canonical host name
  config.middleware.use Rack::CanonicalHost, ENV.fetch("APPLICATION_HOST")
      RUBY

      inject_into_file(
        'config/environments/production.rb',
        config,
        after: 'Rails.application.configure do'
      )
    end

    def enable_rack_deflater
      config = <<-RUBY

  # Enable deflate / gzip compression of controller-generated responses
  config.middleware.use Rack::Deflater
      RUBY

      inject_into_file(
        'config/environments/production.rb',
        config,
        after: serve_static_files_line
      )
    end

    def setup_staging_environment
      staging_file = 'config/environments/staging.rb'
      copy_file 'staging.rb', staging_file

      config = <<-RUBY

Rails.application.configure do
  # ...
end
      RUBY

      append_file staging_file, config
    end

    def setup_secret_token
      template 'secrets.yml', 'config/secrets.yml', force: true
    end

    def disallow_wrapping_parameters
      remove_file 'config/initializers/wrap_parameters.rb'
    end

    def create_shared_javascripts
      copy_file '_javascript.html.erb', 'app/views/application/_javascript.html.erb'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb', 'config/database.yml',
               force: true
      template 'postgresql_database.yml.erb', 'config/database.yml.sample',
               force: true
    end

    def create_database
      bundle_command 'exec rake db:drop db:create db:migrate db:seed'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{Onotole::RUBY_VERSION}\n"
    end

    def configure_ci
      template 'circle.yml.erb', 'circle.yml'
    end

    def configure_i18n_for_missing_translations
      raise_on_missing_translations_in('development')
      raise_on_missing_translations_in('test')
    end

    def configure_background_jobs_for_rspec
      rails_generator 'delayed_job:active_record'
    end

    def configure_time_formats
      remove_file 'config/locales/en.yml'
      template 'config_locales_en.yml.erb', 'config/locales/en.yml'
    end

    def configure_rack_timeout
      rack_timeout_config = 'Rack::Timeout.timeout = (ENV["RACK_TIMEOUT"] || 10).to_i'
      append_file 'config/environments/production.rb', rack_timeout_config
    end

    def configure_simple_form
      if user_choose?(:bootstrap3_sass) || user_choose?(:bootstrap3)
        rails_generator 'simple_form:install --bootstrap'
      else
        rails_generator 'simple_form:install'
      end
    end

    def configure_active_job
      configure_application_file(
        'config.active_job.queue_adapter = :delayed_job'
      )
      configure_environment 'test', 'config.active_job.queue_adapter = :inline'
    end

    def fix_i18n_deprecation_warning
      config = '    config.i18n.enforce_available_locales = true'
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_puma
      copy_file 'puma.rb', 'config/puma.rb'
    end

    def set_up_forego
      copy_file 'Procfile', 'Procfile'
    end

    def install_refills
      rails_generator 'refills:import flashes'
      run 'rm app/views/refills/_flashes.html.erb'
      run 'rmdir app/views/refills'
    end

    def copy_dotfiles
      directory 'dotfiles', '.', force: true
    end

    def create_heroku_apps(flags)
      create_staging_heroku_app(flags)
      create_production_heroku_app(flags)
    end

    def provide_deploy_script
      copy_file 'bin_deploy', 'bin/deploy'

      instructions = <<-MARKDOWN

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production
      MARKDOWN

      append_file 'README.md', instructions
      run 'chmod a+x bin/deploy'
    end

    def configure_automatic_deployment
      deploy_command = <<-YML.strip_heredoc
      deployment:
        staging:
          branch: master
          commands:
            - bin/deploy staging
      YML

      append_file 'circle.yml', deploy_command
    end

    def setup_spring
      bundle_command 'exec spring binstub --all'
      bundle_command 'exec spring stop'
    end

    def copy_miscellaneous_files
      copy_file 'browserslist', 'browserslist'
      copy_file 'errors.rb', 'config/initializers/errors.rb'
      copy_file 'json_encoding.rb', 'config/initializers/json_encoding.rb'
    end

    def remove_config_comment_lines
      config_files = [
        'application.rb',
        'environment.rb',
        'environments/development.rb',
        'environments/production.rb',
        'environments/test.rb'
      ]

      config_files.each do |config_file|
        cleanup_comments File.join(destination_root, "config/#{config_file}")
      end
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
                      /Rails\.application\.routes\.draw do.*end/m,
                      "Rails.application.routes.draw do\nend"
    end

    def disable_xml_params
      copy_file 'disable_xml_params.rb',
                'config/initializers/disable_xml_params.rb'
    end

    def setup_default_rake_task
      append_file 'Rakefile' do
        <<-EOS
task(:default).clear
task default: [:spec]

if defined? RSpec
  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end
end
        EOS
      end
    end

    # def rvm_bundler_stubs_install
    #   if system "rvm -v | grep 'rvm.io'"
    #     run 'chmod +x $rvm_path/hooks/after_cd_bundler'
    #     run 'bundle install --binstubs=./bundler_stubs'
    #   end
    # end

    def user_gems_from_args_or_default_set
      gems_flags = []
      options.each { |gem, usage| gems_flags.push(gem.to_sym) if usage }
      gems = GEMPROCLIST & gems_flags
      if gems.empty?
        AppBuilder.user_choice = DEFAULT_GEMSET
      else
        gems.each { |gem| AppBuilder.user_choice << gem }
      end
      add_user_gems
    end

    def delete_comments
      return unless options[:clean_comments] || user_choose?(:clean_comments)
      cleanup_comments 'Gemfile'
      remove_config_comment_lines
      remove_routes_comment_lines
    end

    def prevent_double_usage
      unless !pgsql_db_exist?("#{app_name}_development") || !pgsql_db_exist?("#{app_name}_test")
        say_color RED, "   YOU HAVE EXISTING DB WITH #{app_name.upcase}!!!"
        say_color RED, "   WRITE 'Y' TO CONTINUE WITH DELETION OF ALL DATA"
        say_color RED, '   ANY OTHER INPUT FOR EXIT'
        exit 0 unless STDIN.gets.chomp == 'Y'
      end
    end
  end
end
