# frozen_string_literal: true
module Onotole
  module DefalutScripts
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

    def enable_rack_deflater
      config = <<-RUBY

  # Enable deflate / gzip compression of controller-generated responses
  # more info https://robots.thoughtbot.com/content-compression-with-rack-deflater
  # rack-mini-profiler does not work with this option
  config.middleware.use Rack::Deflater

      RUBY

      inject_into_file(
        'config/environments/production.rb',
        config,
        after: serve_static_files_line
      )
    end

    def set_up_forego
      template 'Procfile.erb', 'Procfile', force: true
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
      copy_file 'secrets.yml', 'config/secrets.yml', force: true
      # strange bug with ERB in ERB. solved this way
      replace_in_file 'config/secrets.yml',
                      "<%= ENV['SECRET_KEY_BASE'] %>",
                      "<%= ENV['#{app_name.upcase}_SECRET_KEY_BASE'] %>"
    end

    def disallow_wrapping_parameters
      remove_file 'config/initializers/wrap_parameters.rb'
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

    def configure_background_jobs_for_rspec
      rails_generator 'delayed_job:active_record'
    end

    # copy ru_locale here also. Update in future
    def configure_time_formats
      remove_file 'config/locales/en.yml'
      template 'config_locales_en.yml.erb', 'config/locales/en.yml'
      template 'config_locales_ru.yml.erb', 'config/locales/ru.yml'
    end

    def configure_i18n_for_missing_translations
      raise_on_missing_translations_in('development')
      raise_on_missing_translations_in('test')
    end

    def configure_rack_timeout
      rack_timeout_config = 'Rack::Timeout.timeout = (ENV["RACK_TIMEOUT"] || 10).to_i'
      append_file 'config/environments/production.rb', rack_timeout_config
    end

    def fix_i18n_deprecation_warning
      config = '    config.i18n.enforce_available_locales = true'
      inject_into_class 'config/application.rb', 'Application', config
    end

    def copy_dotfiles
      directory 'dotfiles', '.', force: true
      template 'dotenv.erb', '.env'
      template 'dotenv_production.erb', '.env.production'
    end

    def setup_spring
      bundle_command 'exec spring binstub --all'
      bundle_command 'exec spring stop'
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

    def copy_miscellaneous_files
      copy_file 'browserslist', 'browserslist'
      copy_file 'errors.rb', 'config/initializers/errors.rb'
      copy_file 'json_encoding.rb', 'config/initializers/json_encoding.rb'
    end

    def enable_rack_canonical_host
      config = <<-RUBY

  if ENV.fetch("HEROKU_APP_NAME", "").include?("staging-pr-")
    ENV["#{app_name.upcase}_APPLICATION_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
  end

  # Ensure requests are only served from one, canonical host name
  config.middleware.use Rack::CanonicalHost, ENV.fetch("#{app_name.upcase}_APPLICATION_HOST")
      RUBY

      inject_into_file(
        'config/environments/production.rb',
        config,
        after: 'Rails.application.configure do'
      )
    end

    def readme
      template 'README.md.erb', 'README.md'
    end

    def configure_support_path
      mkdir_and_touch 'app/support'
      copy_file 'support.rb', 'config/initializers/support.rb'

      config = "\n    config.autoload_paths << Rails.root.join('app/support')\n"
      inject_into_class 'config/application.rb', 'Application', config
    end

    def apply_vendorjs_folder
      inject_into_file(AppBuilder.js_file, "//= require_tree ../../../vendor/assets/javascripts/.\n", before: '//= require_tree .')
    end

    def add_dotenv_to_startup
      inject_into_file('config/application.rb', "\nDotenv::Railtie.load\n", after: 'Bundler.require(*Rails.groups)')
    end

    def provide_kill_postgres_connections_task
      copy_file 'kill_postgress_conections.rake', 'lib/tasks/kill_postgress_conections.rake'
    end

    def seeds_organisation
      remove_file 'db/seeds.rb'
      copy_file 'seeds.rb', 'db/seeds.rb'
      mkdir_and_touch 'db/seeds'
    end
  end
end
