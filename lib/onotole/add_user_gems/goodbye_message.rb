# frozen_string_literal: true
module Onotole
  module Goodbye
    def show_goodbye_message
      github_check
      airbrake_check
      graphviz_check
      image_optim_check
      rack_cors_check
      ckeditor_check
      devise_user_check
      say_color BOLDGREEN, "Congratulations! Onotole gives you: 'Intellect+= 1'"
    end

    def github_check
      return unless user_choose? :create_github_repo
      say_color BOLDGREEN, "You can 'git push -u origin master' to your new repo
       #{app_name} or check log for errors"
    end

    def graphviz_check
      return unless user_choose?(:railroady)
      return if system('dot -? > /dev/null && neato -? > /dev/null')
      say_color YELLOW, 'Install graphviz for Railroady gem'
    end

    def airbrake_check
      return unless user_choose? :airbrake
      say_color YELLOW, "Remember to run 'rails generate airbrake' with your API key."
    end

    def image_optim_check
      return unless user_choose? :image_optim
      say_color YELLOW, "You may install 'svgo' for 'image_optim' by `npm install -g svgo`"
      say_color YELLOW, "You may install 'pngout' for 'image_optim' from http://www.jonof.id.au/kenutils"
      say_color YELLOW, 'By default this tools are switch off in image_optim.rb'
    end

    def rack_cors_check
      return unless user_choose? :rack_cors
      say_color YELLOW, 'Check your config/application.rb file for rack-cors settings for security.'
    end

    def ckeditor_check
      return unless user_choose? :ckeditor
      say_color YELLOW, 'Visit ckeditor homepage and install back-end for it.'
    end

    def devise_user_check
      return unless AppBuilder.devise_model
      say_color GREEN, 'Turn on devise auth in application.rb or in your controlled. It is turned off by default'
    end
  end
end
