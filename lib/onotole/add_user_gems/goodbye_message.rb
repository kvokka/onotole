# frozen_string_literal: true
module Onotole
  module Goodbye
    def show_goodbye_message
      github_check
      airbrake_check
      graphviz_check
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
  end
end
