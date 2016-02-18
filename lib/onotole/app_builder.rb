# frozen_string_literal: true
require 'forwardable'
require 'pry'
Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), '../')) + '/**/*.rb'].each do |file|
  require file
end

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
    include Onotole::DefaultFrontend
    include Onotole::DefalutScripts
    include Onotole::Deploy
    extend Forwardable

    @use_asset_pipelline = true
    @user_choice = []
    @app_file_scss = 'app/assets/stylesheets/application.scss'
    @app_file_css = 'app/assets/stylesheets/application.css'
    @js_file = 'app/assets/javascripts/application.js'
    @active_admin_theme_selected = false
    @quiet = true

    class << self
       attr_accessor :use_asset_pipelline,
                     :devise_model,
                     :user_choice, :app_file_scss,
                     :app_file_css, :js_file, :quiet, :active_admin_theme_selected
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

    def set_up_hound
      copy_file 'hound.yml', '.hound.yml'
    end

    def configure_newrelic
      template 'newrelic.yml.erb', 'config/newrelic.yml'
    end

    def configure_ci
      template 'circle.yml.erb', 'circle.yml'
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

    def configure_puma
      copy_file 'puma.rb', 'config/puma.rb'
    end

    # def rvm_bundler_stubs_install
    #   if system "rvm -v | grep 'rvm.io'"
    #     run 'chmod +x $rvm_path/hooks/after_cd_bundler'
    #     run 'bundle install --binstubs=./bundler_stubs'
    #   end
    # end

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
