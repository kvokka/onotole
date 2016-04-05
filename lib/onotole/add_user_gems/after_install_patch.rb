# frozen_string_literal: true
module Onotole
  module AfterInstallPatch
    def post_init
      install_queue = [
        :fotoramajs,
        :underscore_rails,
        :gmaps4rails,
        :mailcatcher,
        :rack_cors,
        :devise,
        :validates_timeliness,
        :paper_trail,
        :responders,
        :typus,
        :annotate,
        :overcommit,
        :activeadmin,
        :active_admin_theme,
        :acive_skin,
        :flattened_active_admin,
        :face_of_active_admin,
        :active_admin_bootstrap,
        :rails_admin,
        :guard,
        :guard_rubocop,
        :bootstrap3_sass,
        :bootstrap3,
        :devise_bootstrap_views,
        :active_admin_theme,
        :font_awesome_sass,
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
                         "\nbefore_action :authenticate_#{AppBuilder.devise_model.downcase}!",
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

if ENV['RACK_ENV'] == 'test' || ENV['RACK_ENV'] == 'development'
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
      touch AppBuilder.app_file_scss
      append_file(AppBuilder.app_file_scss,
                  "\n@import 'bootstrap_variables';
                   \n@import 'bootstrap-sprockets';
                  \n@import 'bootstrap';")
      inject_into_file(AppBuilder.js_file, "\n//= require bootstrap-sprockets",
                       after: '//= require jquery_ujs')
      copy_file 'bootstrap_flash_helper.rb', 'app/helpers/bootstrap_flash_helper.rb'
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
        touch AppBuilder.app_file_css
        inject_into_file(AppBuilder.app_file_css, " *= require normalize-rails\n",
                         after: " * file per style scope.\n *\n")
      else
        touch AppBuilder.app_file_scss
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

    def after_install_paper_trail
      rails_generator 'paper_trail:install'
    end

    def after_install_validates_timeliness
      rails_generator 'validates_timeliness:install'
    end

    def after_install_font_awesome_sass
      if AppBuilder.use_asset_pipelline
        inject_into_file(AppBuilder.app_file_css,
                         " *= require font-awesome-sprockets\n *= require font-awesome\n",
                         after: " * file per style scope.\n *\n")
      else
        touch AppBuilder.app_file_scss
        append_file(AppBuilder.app_file_scss,
                    "\n@import 'font-awesome-sprockets';\n@import 'font-awesome';")
      end
    end

    def after_install_devise_bootstrap_views
      return if AppBuilder.use_asset_pipelline
      touch AppBuilder.app_file_scss
      append_file(AppBuilder.app_file_scss, "\n@import 'devise_bootstrap_views';")
      rails_generator 'devise:views:bootstrap_templates'
    end

    def after_install_active_admin_bootstrap
      return unless user_choose?(:bootstrap3_sass) || user_choose?(:activeadmin)
      AppBuilder.use_asset_pipelline = false
      copy_file 'admin_bootstrap.scss', 'vendor/assets/stylesheets/active_admin/admin_bootstrap.scss'
      copy_file 'active_admin.scss', 'vendor/assets/stylesheets/active_admin.scss'
      remove_file 'app/assets/stylesheets/active_admin.scss'
    end

    def after_install_active_admin_theme
      return unless user_choose? :activeadmin
      File.open('app/assets/stylesheets/active_admin.scss', 'a') do |f|
        f.write "\n@import 'wigu/active_admin_theme';"
      end
    end

    def after_install_acive_skin
      return unless user_choose? :activeadmin
      File.open('app/assets/stylesheets/active_admin.scss', 'a') do |f|
        f.write "\n@import 'active_skin;'\n\\\\$skinLogo: url('admin_logo.png') no-repeat 0 0;"
      end
    end

    def after_install_flattened_active_admin
      return unless user_choose? :activeadmin
      File.open('app/assets/stylesheets/active_admin.scss', 'w') do |f|
        f.write "\n@import 'flattened_active_admin/variables;'
        \n@import 'flattened_active_admin/mixins;'
        \n@import 'flattened_active_admin/base;'"
      end
      rails_generator 'flattened_active_admin:variables'
    end

    def after_install_face_of_active_admin
      return unless user_choose? :activeadmin
      File.open('app/assets/stylesheets/active_admin.scss', 'w') do |f|
        f.write "\n@import 'face_of_active_admin/variables;'
        \n@import 'face_of_active_admin/mixins;'
        \n@import 'face_of_active_admin/base;'"
      end
      append_file 'app/assets/javascripts/active_admin.js.coffee',
                  "\n#= require face_of_active_admin/base"
      rails_generator 'face_of_active_admin:variables'
    end

    def after_install_fotoramajs
      if AppBuilder.use_asset_pipelline
        inject_into_file(AppBuilder.app_file_css, " *= require fotorama\n",
                         after: " * file per style scope.\n *\n")
      else
        touch AppBuilder.app_file_scss
        append_file(AppBuilder.app_file_scss, "\n@import 'fotorama';")
      end
      inject_into_file(AppBuilder.js_file, "\n//= require fotorama",
                       after: '//= require jquery_ujs')
    end

    def after_install_underscore_rails
      inject_into_file(AppBuilder.js_file, "\n//= require underscore",
                       after: '//= require jquery_ujs')
    end

    def after_install_gmaps4rails
      inject_into_file(AppBuilder.js_file, "\n//= require gmaps/google",
                       after: '//= require underscore')
    end

    def after_install_mailcatcher
      config = <<-RUBY

  if system ('lsof -i :1025 | grep mailcatch  > /dev/null')
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }
  else
    config.action_mailer.delivery_method = :file
  end

      RUBY

      replace_in_file 'config/environments/development.rb',
                      'config.action_mailer.delivery_method = :file', config
    end

    def after_install_rack_cors
      config = <<-RUBY

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end
  end
end
