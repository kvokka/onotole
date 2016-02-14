# frozen_string_literal: true
module Onotole
  module Deploy
    def provide_deploy_script
      copy_file 'bin_deploy', 'bin/deploy'

      instructions = <<-MARKDOWN

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production
      MARKDOWN

      append_file 'README.md', instructions
      run 'chmod a+x bin/deploy'
    end

    def configure_automatic_deployment
      deploy_command = <<-YML.strip_heredoc
      deployment:
        staging:
          branch: master
          commands:
            - bin/deploy staging
      YML

      append_file 'circle.yml', deploy_command
    end

    def create_heroku_apps(flags)
      create_staging_heroku_app(flags)
      create_production_heroku_app(flags)
    end
  end
end
