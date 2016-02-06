module Onotole
  module UserGemsMenu
    def users_gems
      choose_authenticate_engine
      choose_template_engine
      choose_frontend
      # Placeholder for other gem additions
      # menu description in add_gems_in_menu.rb

      choose_undroup_gems
      ask_cleanup_commens
      users_init_commit_choice
      add_github_repo_creation_choice
      add_user_gems
    end
  end
end
