# frozen_string_literal: true
module Onotole
  module Mail
    def configure_action_mailer
      action_mailer_host 'development', %("localhost:3000")
      action_mailer_host 'test', %("www.example.com")
      action_mailer_host 'production', %{ENV.fetch("APPLICATION_HOST")}
    end

    def configure_action_mailer_in_specs
      copy_file 'action_mailer.rb', 'spec/support/action_mailer.rb'
    end

    def configure_smtp
      copy_file 'smtp.rb', 'config/smtp.rb'

      prepend_file 'config/environments/production.rb',
                   %{require Rails.root.join("config/smtp")\n}

      config = <<-RUBY

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
      RUBY

      inject_into_file 'config/environments/production.rb', config,
                       after: 'config.action_mailer.raise_delivery_errors = false'
    end

    def set_test_delivery_method
      inject_into_file(
        'config/environments/development.rb',
        "\n  config.action_mailer.delivery_method = :test",
        after: 'config.action_mailer.raise_delivery_errors = true'
      )
    end
  end
end
