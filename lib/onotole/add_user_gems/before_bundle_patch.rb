module Onotole
  module BeforeBundlePatch
    def setup_default_gems
      add_to_user_choise(:normalize)
    end

    def add_user_gems
      GEMPROCLIST.each do |g|
        send "add_#{g}_gem" if user_choose? g.to_sym
      end
      # add_foo_bar_gem if user_choose?(:foo) && user_choose?(:bar)
    end

    def add_haml_gem
      inject_into_file('Gemfile', "\ngem 'haml-rails'", after: '# user_choice')
    end

    def add_dotenv_heroku_gem
      inject_into_file('Gemfile', "\n  gem 'dotenv-heroku'",
                       after: 'group :development do')
      append_file 'Rakefile', %(\nrequire 'dotenv-heroku/tasks' if ENV['RAILS_ENV'] == 'test' || ENV['RAILS_ENV'] == 'development'\n)
    end

    def add_slim_gem
      inject_into_file('Gemfile', "\ngem 'slim-rails'", after: '# user_choice')
      inject_into_file('Gemfile', "\n  gem 'html2slim'", after: 'group :development do')
    end

    def add_rails_db_gem
      inject_into_file('Gemfile', "\n  gem 'rails_db'\n  gem 'axlsx_rails'",
                       after: 'group :development do')
    end

    def add_rubocop_gem
      inject_into_file('Gemfile', "\n  gem 'rubocop', require: false",
                       after: 'group :development do')
      copy_file 'rubocop.yml', '.rubocop.yml'
    end

    def add_guard_gem
      t = <<-TEXT.chomp

  gem 'guard'
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'guard-puma'
  gem 'guard-migrate'
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
  gem 'rb-inotify', github: 'kvokka/rb-inotify'
      TEXT
      inject_into_file('Gemfile', t, after: 'group :development do')
    end

    def add_guard_rubocop_gem
      if user_choose?(:guard) && user_choose?(:rubocop)
        inject_into_file('Gemfile', "\n  gem 'guard-rubocop'",
                         after: 'group :development do')
      else
        say_color RED, 'You need Guard & Rubocop gems for this add-on'
      end
    end

    def add_meta_request_gem
      inject_into_file('Gemfile', "\n  gem 'meta_request' # link for chrome add-on. https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg",
                       after: 'group :development do')
    end

    def add_faker_gem
      inject_into_file('Gemfile', "\n  gem 'faker'", after: 'group :development, :test do')
    end

    def add_bundler_audit_gem
      copy_file 'bundler_audit.rake', 'lib/tasks/bundler_audit.rake'
      append_file 'Rakefile', %(\ntask default: "bundler:audit"\n)
    end

    def add_bootstrap3_sass_gem
      inject_into_file('Gemfile', "\ngem 'bootstrap-sass', '~> 3.3.6'",
                       after: '# user_choice')
    end

    def add_airbrake_gem
      inject_into_file('Gemfile', "\ngem 'airbrake'",
                       after: '# user_choice')
    end

    def add_bootstrap3_gem
      inject_into_file('Gemfile', "\ngem 'twitter-bootstrap-rails'",
                       after: '# user_choice')
      inject_into_file('Gemfile', "\ngem 'devise-bootstrap-views'",
                       after: '# user_choice') if user_choose?(:devise)
    end

    def add_devise_gem
      devise_conf = <<-TEXT

  # v.3.5 syntax. will be deprecated in 4.0
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |user_params|
      user_params.permit(:email, :password)
    end

    devise_parameter_sanitizer.for(:sign_up) do |user_params|
      user_params.permit(:email, :password, :password_confirmation)
    end
  end
  protected :configure_permitted_parameters
    TEXT
      inject_into_file('Gemfile', "\ngem 'devise'", after: '# user_choice')
      inject_into_file('app/controllers/application_controller.rb',
                       "\nbefore_action :configure_permitted_parameters, if: :devise_controller?",
                       after: 'class ApplicationController < ActionController::Base')

      inject_into_file('app/controllers/application_controller.rb', devise_conf,
                       after: 'protect_from_forgery with: :exception')
      copy_file 'devise_rspec.rb', 'spec/support/devise.rb'
    end

    def add_will_paginate_gem
      inject_into_file('Gemfile', "\ngem 'will_paginate', '~> 3.0.6'",
                       after: '# user_choice')
      inject_into_file('Gemfile', "\ngem 'will_paginate-bootstrap'",
                       after: '# user_choice') if user_choose?(:bootstrap3) ||
                                                  user_choose?(:bootstrap3_sass)
    end

    def add_responders_gem
      inject_into_file('Gemfile', "\ngem 'responders'", after: '# user_choice')
    end

    def add_hirbunicode_gem
      inject_into_file('Gemfile', "\ngem 'hirb-unicode'", after: '# user_choice')
    end

    def add_tinymce_gem
      inject_into_file('Gemfile', "\ngem 'tinymce-rails'", after: '# user_choice')
      inject_into_file('Gemfile', "\ngem 'tinymce-rails-langs'", after: '# user_choice')
      copy_file 'tinymce.yml', 'config/tinymce.yml'
    end

    def add_annotate_gem
      inject_into_file('Gemfile', "\n  gem 'annotate'", after: 'group :development do')
    end

    def add_overcommit_gem
      inject_into_file('Gemfile', "\n  gem 'overcommit'", after: 'group :development do')
      copy_file 'onotole_overcommit.yml', '.overcommit.yml'
      rubocop_overcommit = <<-OVER
  RuboCop:
    enabled: ture
    description: 'Analyzing with RuboCop'
    required_executable: 'rubocop'
    flags: ['--format=emacs', '--force-exclusion', '--display-cop-names']
    install_command: 'gem install rubocop'
    include:
      - '**/*.gemspec'
      - '**/*.rake'
      - '**/*.rb'
      - '**/Gemfile'
      - '**/Rakefile'

      OVER
      append_file '.overcommit.yml', rubocop_overcommit if user_choose?(:rubocop)
    end
  end
end
