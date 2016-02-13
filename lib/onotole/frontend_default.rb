# frozen_string_literal: true
module Onotole
  module FrontendDefault
    def configure_quiet_assets
      config = "\n    config.quiet_assets = true\n"
      inject_into_class 'config/application.rb', 'Application', config
    end

    def setup_asset_host
      replace_in_file 'config/environments/production.rb',
                      "# config.action_controller.asset_host = 'http://assets.example.com'",
                      'config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))'

      replace_in_file 'config/initializers/assets.rb',
                      "config.assets.version = '1.0'",
                      'config.assets.version = (ENV["ASSETS_VERSION"] || "1.0")'

      inject_into_file(
        'config/environments/production.rb',
        '  config.static_cache_control = "public, max-age=#{1.year.to_i}"',
        after: serve_static_files_line
      )
    end

    def create_shared_flashes
      copy_file '_flashes.html.erb', 'app/views/application/_flashes.html.erb'
      copy_file 'flashes_helper.rb', 'app/helpers/flashes_helper.rb'
    end

    def create_application_layout
      template 'onotole_layout.html.erb.erb',
               'app/views/layouts/application.html.erb',
               force: true
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'application.scss',
                'app/assets/stylesheets/application.scss'
    end

    def install_bitters
      bundle_command 'exec bitters install --path app/assets/stylesheets'
    end

    def customize_error_pages
      meta_tags = <<-EOS
  <meta charset="utf-8" />
  <meta name="ROBOTS" content="NOODP" />
  <meta name="viewport" content="initial-scale=1" />
      EOS

      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, after: "<head>\n"
        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
      end
    end

    def setup_segment
      copy_file '_analytics.html.erb',
                'app/views/application/_analytics.html.erb'
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end
  end
end
