# frozen_string_literal: true
module Onotole
  module Tests
    def generate_rspec
      ['app/views/pages',
       'spec/lib',
       'spec/controllers',
       'spec/helpers',
       'spec/support/matchers',
       'spec/support/mixins',
       'spec/support/shared_examples'
].each do |dir|
  run "mkdir #{dir}"
  run "touch #{dir}/.keep"
end
      bundle_command 'exec rails generate rspec:install'
    end

    def configure_capybara_webkit
      copy_file 'capybara_webkit.rb', 'spec/support/capybara_webkit.rb'
    end

    def configure_i18n_for_test_environment
      copy_file 'i18n.rb', 'spec/support/i18n.rb'
    end

    def configure_rspec
      remove_file 'spec/rails_helper.rb'
      remove_file 'spec/spec_helper.rb'
      copy_file 'rails_helper.rb', 'spec/rails_helper.rb'
      copy_file 'spec_helper.rb', 'spec/spec_helper.rb'
    end

    def configure_generators
      config = <<-RUBY

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
      generate.fixture_replacement :factory_girl
    end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def enable_database_cleaner
      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def provide_shoulda_matchers_config
      copy_file(
        'shoulda_matchers_config_rspec.rb',
        'spec/support/shoulda_matchers.rb'
      )
    end

    def configure_spec_support_features
      empty_directory_with_keep_file 'spec/features'
      empty_directory_with_keep_file 'spec/support/features'
    end

    def set_up_factory_girl_for_rspec
      copy_file 'factory_girl_rspec.rb', 'spec/support/factory_girl.rb'
    end

    def generate_factories_file
      copy_file 'factories.rb', 'spec/factories.rb'
    end

    def raise_on_missing_assets_in_test
      inject_into_file(
        'config/environments/test.rb',
        "\n  config.assets.raise_runtime_errors = true",
        after: 'Rails.application.configure do'
      )
    end
  end
end
