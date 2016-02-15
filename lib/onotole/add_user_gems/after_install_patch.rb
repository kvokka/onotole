# frozen_string_literal: true
module Onotole
  module AfterInstallPatch
    def post_init
      install_queue = [:devise,
                       :responders,
                       :typus,
                       :annotate,
                       :overcommit,
                       :activeadmin,
                       :rails_admin,
                       :guard,
                       :guard_rubocop,
                       :bootstrap3_sass,
                       :bootstrap3,
                       :active_admin_theme,
                       :normalize,
                       :tinymce,
                       :rubocop,
                       :create_github_repo]
      install_queue.each { |g| send "after_install_#{g}" if user_choose? g }
      delete_comments
    end

    def after_install_devise
      rails_generator 'devise:install'
      if AppBuilder.devise_model
        rails_generator "devise #{AppBuilder.devise_model.titleize}"
        inject_into_file('app/controllers/application_controller.rb',
                         "\nbefore_action :authenticate_#{AppBuilder.devise_model.titleize}!",
                         after: 'before_action :configure_permitted_parameters, if: :devise_controller?')
      end
      if user_choose?(:bootstrap3)
        rails_generator 'devise:views:bootstrap_templates'
      else
        rails_generator 'devise:views'
      end
    end

    def after_install_rubocop
      run 'touch .rubocop_todo.yml'
      t = <<-TEXT

if ENV['RAILS_ENV'] == 'test' || ENV['RAILS_ENV'] == 'development'
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end
        TEXT
      append_file 'Rakefile', t
      clean_by_rubocop
    end

    def after_install_guard
      bundle_command 'exec guard init'
      replace_in_file 'Guardfile',
                      "guard 'puma' do",
                      'guard :puma, port: 3000 do', quiet_err = true
    end

    def after_install_guard_rubocop
      if user_choose?(:guard) && user_choose?(:rubocop)
        cover_def_by 'Guardfile', 'guard :rubocop do', 'group :red_green_refactor, halt_on_fail: true do'
        cover_def_by 'Guardfile', 'guard :rspec, ', 'group :red_green_refactor, halt_on_fail: true do'

        replace_in_file 'Guardfile',
                        'guard :rubocop do',
                        'guard :rubocop, all_on_start: false do', quiet_err = true
        replace_in_file 'Guardfile',
                        'guard :rspec, cmd: "bundle exec rspec" do',
                        "guard :rspec, cmd: 'bundle exec rspec', failed_mode: :keep do", quiet_err = true
      end
    end

    def after_install_bootstrap3_sass
      setup_stylesheets
      AppBuilder.use_asset_pipelline = false
      append_file(AppBuilder.app_file_scss,
                  "\n@import 'bootstrap-sprockets';\n@import 'bootstrap';")
      inject_into_file(AppBuilder.js_file, "\n//= require bootstrap-sprockets",
                       after: '//= require jquery_ujs')
    end

    def after_install_bootstrap3
      AppBuilder.use_asset_pipelline = true
      remove_file 'app/views/layouts/application.html.erb'
      rails_generator 'bootstrap:install static'
      rails_generator 'bootstrap:layout'
      inject_into_file('app/assets/stylesheets/bootstrap_and_overrides.css',
                       "  =require devise_bootstrap_views\n",
                       before: '  */')
    end

    def after_install_normalize
      if AppBuilder.use_asset_pipelline
        inject_into_file(AppBuilder.app_file_css, " *= require normalize-rails\n",
                         after: " * file per style scope.\n *\n")
      else
        inject_into_file(AppBuilder.app_file_scss, "\n@import 'normalize-rails';",
                         after: '@charset "utf-8";')
      end
    end

    def after_install_tinymce
      inject_into_file(AppBuilder.js_file, "\n//= require tinymce-jquery",
                       after: '//= require jquery_ujs')
    end

    def after_install_responders
      rails_generator 'responders:install'
    end

    def after_install_create_github_repo
      create_github_repo(app_name)
    end

    def after_install_annotate
      rails_generator 'annotate:install'
    end

    def after_install_overcommit
      bundle_command 'exec overcommit --install'
      bundle_command 'exec overcommit --sign'
      inject_into_file('bin/setup', "\novercommit --install\novercommit --sign", after: '# User addons installation')
    end

    def after_install_activeadmin
      if user_choose? :devise
        rails_generator 'active_admin:install'
      else
        rails_generator 'active_admin:install --skip-users'
      end
    end

    def after_install_rails_admin
      rails_generator 'rails_admin:install'
    end

    def after_install_typus
      rails_generator 'typus'
      rails_generator 'typus:migration'
      rails_generator 'typus:views'
    end

    def after_install_active_admin_theme
      append_file('app/assets/stylesheets/active_admin.scss',
                  "\n@import 'wigu/active_admin_theme';")
    end
  end
end
