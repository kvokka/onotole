# frozen_string_literal: true
module Onotole
  module EditMenuQuestions
    def choose_frontend
      # do not forget add in def configure_simple_form new frameworks
      variants = { none:             'No front-end framework',
                   bootstrap3_sass:  'Twitter bootstrap v.3 sass',
                   bootstrap3:       'Twitter bootstrap v.3 asset pipeline',
                   materialize_sass: 'Materialize Sass version for Rails Asset Pipeline (http://materializecss.com)' }
      gem = choice 'Select front-end framework: ', variants
      add_to_user_choise(gem) if gem
    end

    def choose_template_engine
      variants = { none: 'Erb', slim: 'Slim', haml: 'Haml' }
      gem = choice 'Select markup language: ', variants
      add_to_user_choise(gem) if gem
    end

    def choose_authenticate_engine
      variants = { none: 'None', devise: 'devise 4', devise_with_model: 'devise 4 vs pre-installed model' }
      gem = choice 'Select authenticate engine: ', variants
      if gem == :devise_with_model
        AppBuilder.devise_model = ask_stylish 'Enter devise model name:'
        gem = :devise
      end
      add_to_user_choise(gem) if gem
    end

    def choose_authorization_engine
      variants = { none: 'None', pundit: 'Pundit' }
      gem = choice 'Select authorization engine: ', variants
      add_to_user_choise(gem) if gem
    end

    def choose_cms_engine
      variants = { none:        'None',
                   activeadmin: 'Activeadmin CMS (if devise selected Admin model will create automatic)',
                   rails_admin: 'Rails admin CMS',
                   rails_db:    'Rails DB. Simple pretty view in browser & xls export for models',
                   typus:       'Typus control panel to allow trusted users edit structured content.' }
      gem = choice 'Select control panel or CMS: ', variants
      add_to_user_choise(gem) if gem
      show_active_admin_plugins_submenu
    end

    def show_active_admin_plugins_submenu
      return unless user_choose? :activeadmin
      variants = {            none:                     'None',
                              active_admin_import:      'The most efficient way to import for ActiveAdmin',
                              active_admin_theme:       'Theme, flat skin',
                              active_skin:              'Theme, flat, nice, good maintenance',
                              flattened_active_admin:   'Theme, bring your Active Admin up-to-date with this customizable add on',
                              active_admin_bootstrap:   'Theme, simple bootstrap (sass) elements',
                              face_of_active_admin:     'Theme for ActiveAdmin with glyphicons and flattens',
                              active_admin_simple_life: 'Automatize routine with creation simple menus in ActiveAdmin with minimum code duplication.' }
      themes = [:active_admin_theme, :active_skin, :flattened_active_admin]
      multiple_choice('Select activeadmin plug-ins (Themes are SASS or SCSS only).', variants).each do |gem|
        add_to_user_choise gem
        if themes.include? gem
          AppBuilder.use_asset_pipelline = false
          AppBuilder.active_admin_theme_selected = true
        end
      end
    end

    def choose_pagimation
      if user_choose? :activeadmin
        add_to_user_choise(:kaminari)
        return
      end
      variants = { none:          'None',
                   will_paginate: 'Will paginate',
                   kaminari:      'Kaminari' }
      gem = choice 'Select paginator: ', variants
      add_to_user_choise(gem) if gem
    end

    def choose_develoder_tools
      variants = { none:                 'None',
                   faker:                'Gem for generate fake data in testing',
                   rubocop:              'Code inspector and code formatting tool',
                   rubycritic:           'A Ruby code quality reporter',
                   guard:                'Guard (with RSpec, livereload, rails, migrate, bundler)',
                   guard_rubocop:        'Auto-declare code miss in guard',
                   bundler_audit:        'Extra possibilities for gems version control',
                   airbrake:             'Airbrake error logging',
                   annotate:             'Annotate Rails classes with schema and routes info',
                   overcommit:           'A fully configurable and extendable Git hook manager',
                   railroady:            'Model and controller UML class diagram generator',
                   hirbunicode:          'Hirb unicode support',
                   dotenv_heroku:        'dotenv-heroku support',
                   image_optim:          'Optimize images (jpeg, png, gif, svg) using external utilities',
                   mailcatcher:          'Catches mail and serves it through a dream. http://mailcatcher.me',
                   rack_mini_profiler:   'Middleware that displays speed badge for every html page.',
                   flamegraph:           'Rack_mini_profiler awesome graphics generator. Need stackprof gem',
                   stackprof:            'A sampling call-stack profiler for ruby 2.1+',
                   git_up:               'git-up(1) -- fetch and rebase all locally-tracked remote branches',
                   meta_request:         'Rails meta panel in chrome console.'\
                   " Very usefull in\n#{' ' * 24}AJAX debugging. Link for chrome"\
                   " add-on in Gemfile.\n#{' ' * 24}Do not delete comments if you need this link",
                   active_record_doctor: 'Active Record Doctor helps to index unindexed foreign keys' }
      multiple_choice('Write numbers of all preferred gems.', variants).each do |gem|
        add_to_user_choise gem
      end
    end

    def choose_wysiwyg
      variants = { none:     'None',
                   ckeditor: 'CKEditor text editor designed for web content creation.',
                   tinymce:  'TinyMCE with the Rails asset pipeline' }
      gem = choice 'Select wysiwyg: ', variants
      add_to_user_choise(gem) if gem
    end

    def choose_undroup_gems
      variants = { none:                 'None',
                   responders:           'A set of responders modules to dry up your Rails 4.2+ app.',
                   activerecord_import:  'A library for bulk inserting data using ActiveRecord',
                   paper_trail:          'Track changes to your models data. For auditing or versioning',
                   cyrillizer:           'Character conversion from latin to cyrillic and vice versa',
                   validates_timeliness: 'Date and time validation plugin for ActiveModel and Rails',
                   font_awesome_sass:    'Font-Awesome Sass gem for use in Ruby/Rails projects',
                   fotoramajs:           'Fotorama JS gallery for Rails http://fotorama.io/',
                   prawn:                'Prawn gem for PDF support vs prawn-table for easy tables',
                   axlsx_rails:          'XLS support, cyrillic support, good support at all',
                   geocoder:             'Complete Ruby geocoding solution. http://www.rubygeocoder.com',
                   gmaps4rails:          'Enables easy Google map + overlays creation. http://apneadiving.github.io/',
                   rack_cors:            'Rack Middleware for handling Cross-Origin Resource Sharing (CORS).',
                   newrelic_rpm:         'New Relic RPM Ruby Agent http://www.newrelic.com',
                   invisible_captcha:    'Unobtrusive and flexible spam protection for RoR apps',
                   sitemap_generator:    'SitemapGenerator is the easiest way to generate Sitemaps in Ruby.',
                   therubyracer:         'JS code execution in Ruby' }
      multiple_choice('Write numbers of all preferred gems.', variants).each do |gem|
        add_to_user_choise gem
      end
      add_to_user_choise :underscore_rails if user_choose?(:gmaps4rails)
    end

    def choose_cache_storage
      variants = {            none:            'Default',
                              redis:           'Redis db ruby library',
                              redis_rails:     'Provides a full set of stores (Cache, Session, HTTP Cache)',
                              redis_namespace: 'Provides an interface to a namespaced subset of your redis keyspace' }
      multiple_choice('Select cache storage and plug-ins.', variants).each do |gem|
        add_to_user_choise gem
      end
      add_to_user_choise :redis if user_choose?(:redis_rails) || user_choose?(:redis_namespace)
    end

    def choose_file_storage
      variants = { none:                      'None',
                   carrierwave:               'carrierwave v0.10',
                   carrierwave_with_uploader: 'carrierwave+mini_magick v0.10 pre-installed uploader' }
      gem = choice 'Select file storage engine: ', variants
      if gem == :carrierwave_with_uploader
        AppBuilder.file_storage_name = ask_stylish('Enter uploader name:').downcase
        gem = :carrierwave
      end
      add_to_user_choise(gem) if gem
    end

    # template for yes/no question
    #
    # def supeawesome_gem
    #   gem_name = __callee__.to_s.gsub(/_gem$/, '')
    #   gem_description = 'Awesome gem description'
    #   add_to_user_choise( yes_no_question( gem_name,
    #           gem_description)) unless options[gem_name]
    # end

    # TODO: move all this to other module
    def users_abstract_model_wrapper_choice
      variants = { none: 'No', abstract_model_wrapper: 'Yes' }
      sel = choice 'Create abstract model wrapper for all models? ', variants
      add_to_user_choise(sel) unless sel == :none
    end

    def users_init_commit_choice
      variants = { none: 'No', gitcommit: 'Yes' }
      sel = choice 'Make init commit in the end? ', variants
      add_to_user_choise(sel) unless sel == :none
    end

    def ask_cleanup_commens
      return if options[:clean_comments]
      variants = { none: 'No', clean_comments: 'Yes' }
      sel = choice 'Delete comments in Gemfile, routes.rb & config files? ',
                   variants
      add_to_user_choise(sel) unless sel == :none
    end

    def add_github_repo_creation_choice
      variants = { none: 'No', create_github_repo: 'Yes' }
      sel = choice "Create github repo #{app_name}?", variants
      add_to_user_choise(sel) unless sel == :none
    end
  end
end
