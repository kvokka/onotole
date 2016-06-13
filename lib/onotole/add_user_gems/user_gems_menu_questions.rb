# frozen_string_literal: true
module Onotole
  module UserGemsMenu
    def users_gems
      choose_cms_engine
      choose_template_engine
      choose_frontend
      choose_authenticate_engine
      choose_authorization_engine
      choose_pagimation
      choose_wysiwyg
      choose_develoder_tools
      choose_cache_storage
      choose_file_storage
      # Placeholder for other gem additions
      # menu description in add_gems_in_menu.rb

      choose_undroup_gems
      ask_cleanup_commens
      users_abstract_model_wrapper_choice
      users_init_commit_choice
      add_github_repo_creation_choice
      setup_default_gems
      add_user_gems
    end
  end
end
