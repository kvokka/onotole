module Onotole
  module EditMenuQuestions
    def choose_frontend
      # do not forget add in def configure_simple_form new frameworks
      variants = { none:            'No front-end framework',
                   bootstrap3_sass: 'Twitter bootstrap v.3 sass',
                   bootstrap3:      'Twitter bootstrap v.3 asset pipeline'
                    }
      gem = choice 'Select front-end framework: ', variants
      add_to_user_choise(gem) if gem
    end

    def choose_template_engine
      variants = { none: 'Erb', slim: 'Slim', haml: 'Haml' }
      gem = choice 'Select markup language: ', variants
      add_to_user_choise(gem) if gem
    end

    def choose_authenticate_engine
      variants = { none: 'None', devise: 'devise', devise_with_model: 'devise vs pre-installed model' }
      gem = choice 'Select authenticate engine: ', variants
      if gem == :devise_with_model
        AppBuilder.devise_model = ask_stylish 'Enter devise model name:'
        gem = :devise
      end
      add_to_user_choise(gem) if gem
    end

    def choose_undroup_gems
      variants = { none:          'None',
                   will_paginate: 'Easy pagination implement',
                   rails_db:      'For pretty view in browser & xls export for models',
                   faker:         'Gem for generate fake data in testing',
                   rubocop:       'Code inspector and code formatting tool',
                   guard:         'Guard (with RSpec, livereload, rails, migrate, bundler)',
                   guard_rubocop: 'Auto-declare code miss in guard',
                   bundler_audit: 'Extra possibilities for gems version control',
                   airbrake:      'Airbrake error logging',
                   responders:    'A set of responders modules to dry up your Rails 4.2+ app.',
                   hirbunicode:   'Hirb unicode support',
                   dotenv_heroku: 'dotenv-heroku support',
                   tinymce:       'Integration of TinyMCE with the Rails asset pipeline',
                   annotate:      'Annotate Rails classes with schema and routes info',
                   meta_request:  "Rails meta panel in chrome console. Very usefull in AJAX debugging.\n#{' ' * 24}Link for chrome add-on in Gemfile.\n#{' ' * 24}Do not delete comments if you need this link"
                    }
      multiple_choice('Write numbers of all preferred gems.', variants).each do |gem|
        add_to_user_choise gem
      end
    end

    # template for yes/no question
    #
    # def supeawesome_gem
    #   gem_name = __callee__.to_s.gsub(/_gem$/, '')
    #   gem_description = 'Awesome gem description'
    #   add_to_user_choise( yes_no_question( gem_name,
    #           gem_description)) unless options[gem_name]
    # end

    def users_init_commit_choice
      variants = { none: 'No', gitcommit: 'Yes' }
      sel = choice 'Make init commit in the end? ', variants
      add_to_user_choise(sel) unless sel == :none
    end

    def ask_cleanup_commens
      unless options[:clean_comments]
        variants = { none: 'No', clean_comments: 'Yes' }
        sel = choice 'Delete comments in Gemfile, routes.rb & config files? ',
                     variants
        add_to_user_choise(sel) unless sel == :none
      end
    end

    def add_github_repo_creation_choice
      variants = { none: 'No', create_github_repo: 'Yes' }
      sel = choice "Create github repo #{app_name}?", variants
      add_to_user_choise(sel) unless sel == :none
    end
  end
end
