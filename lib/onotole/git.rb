# frozen_string_literal: true
module Onotole
  module Git
    def install_user_gems_from_github
      File.readlines('Gemfile').each do |l|
        possible_gem_name = l.match(%r{(?:github:\s+)(?:'|")\w+/(.*)(?:'|")}i)
        install_from_github possible_gem_name[1] if possible_gem_name
      end
    end

    def create_github_repo(repo_name)
      system "hub create #{repo_name}"
    end

    def init_git
      run 'git init'
    end

    def git_init_commit
      return unless user_choose?(:gitcommit)
      say 'Init commit'
      run 'git add .'
      run 'git commit -m "Init commit"'
    end

    def gitignore_files
      remove_file '.gitignore'
      copy_file 'gitignore_file', '.gitignore'
    end
  end
end
