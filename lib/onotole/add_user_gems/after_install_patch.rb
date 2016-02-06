module Onotole
  module AfterInstallPatch
    def post_init
      install_queue = [:responders,
                       :guard,
                       :guard_rubocop,
                       :bootstrap3_sass,
                       :bootstrap3,
                       :devise,
                       :normalize,
                       :tinymce,
                       :rubocop,
                       :create_github_repo]
      install_queue.each { |q| send "after_install_#{q}" }
      delete_comments
    end

    def after_install_devise
      generate 'devise:install' if user_choose? :devise
      if AppBuilder.devise_model && user_choose?(:devise)
        generate "devise #{AppBuilder.devise_model.titleize}"
        inject_into_file('app/controllers/application_controller.rb',
                         "\nbefore_action :authenticate_#{AppBuilder.devise_model.titleize}!",
                         after: 'before_action :configure_permitted_parameters, if: :devise_controller?')
      end
      if user_choose?(:bootstrap3)
        generate 'devise:views:bootstrap_templates'
      else
        generate 'devise:views'
      end
    end

    def after_install_rubocop
      if user_choose? :rubocop
        t = <<-TEXT

if ENV['RAILS_ENV'] == 'test' || ENV['RAILS_ENV'] == 'development'
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end
        TEXT
        append_file 'Rakefile', t
        run 'rubocop -a'
      end
    end

    def after_install_guard
      if user_choose?(:guard)
        run 'guard init'
        replace_in_file 'Guardfile',
                        "guard 'puma' do",
                        'guard :puma, port: 3000 do', quiet_err = true
      end
    end

    def after_install_guard_rubocop
      if user_choose?(:guard_rubocop) && user_choose?(:guard) && user_choose?(:rubocop)

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
      if user_choose? :bootstrap3_sass
        setup_stylesheets
        AppBuilder.use_asset_pipelline = false
        append_file(AppBuilder.app_file_scss,
                    "\n@import 'bootstrap-sprockets';\n@import 'bootstrap';")
        inject_into_file(AppBuilder.js_file, "\n//= require bootstrap-sprockets",
                         after: '//= require jquery_ujs')
      end
    end

    def after_install_bootstrap3
      if user_choose? :bootstrap3
        AppBuilder.use_asset_pipelline = true
        remove_file 'app/views/layouts/application.html.erb'
        generate 'bootstrap:install static'
        generate 'bootstrap:layout'
        inject_into_file('app/assets/stylesheets/bootstrap_and_overrides.css',
                         "  =require devise_bootstrap_views\n",
                         before: '  */')
      end
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
      if user_choose? :tinymce
        inject_into_file(AppBuilder.js_file, "\n//= require tinymce-jquery",
                         after: '//= require jquery_ujs')
      end
    end

    def after_install_responders
      run('rails g responders:install') if user_choose? :responders
    end

    def after_install_create_github_repo
      create_github_repo(app_name) if user_choose? :create_github_repo
    end
  end
end
