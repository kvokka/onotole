# frozen_string_literal: true
module Onotole
  module Helpers
    def yes_no_question(gem_name, gem_description)
      gem_name_color = "#{gem_name.capitalize}.\n"
      variants = { none: 'No', gem_name.to_sym => gem_name_color }
      choice "Use #{gem_name}? #{gem_description}", variants
    end

    def choice(selector, variants)
      unless variants.keys[1..-1].map { |a| options[a] }.include? true
        values = []
        say "\n  #{BOLDGREEN}#{selector}#{COLOR_OFF}"
        variants.each_with_index do |variant, i|
          values.push variant[0]
          say "#{i.to_s.rjust(5)}. #{BOLDBLUE}#{variant[1]}#{COLOR_OFF}"
        end
        answer = ask_stylish('Enter choice:') until (0...variants.length)
                                                    .map(&:to_s).include? answer
        values[answer.to_i] == :none ? nil : values[answer.to_i]
      end
    end

    def multiple_choice(selector, variants)
      values = []
      result = []
      answers = ''
      say "\n  #{BOLDGREEN}#{selector} Use space as separator#{COLOR_OFF}"
      variants.each_with_index do |variant, i|
        values.push variant[0]
        say "#{i.to_s.rjust(5)}. #{BOLDBLUE}#{variant[0]
              .to_s.ljust(20)}-#{COLOR_OFF} #{variant[1]}"
      end
      loop do
        answers = ask_stylish('Enter choices:').split ' '
        break if answers.any? && (answers - (0...variants.length)
                .to_a.map(&:to_s)).empty?
      end
      answers.delete '0'
      answers.uniq.each { |a| result.push values[a.to_i] }
      result
    end

    def raise_on_missing_translations_in(environment)
      config = 'config.action_view.raise_on_missing_translations = true'
      uncomment_lines("config/environments/#{environment}.rb", config)
    end

    def heroku_adapter
      @heroku_adapter ||= Adapters::Heroku.new(self)
    end

    def serve_static_files_line
      "config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?\n"
    end

    def add_gems_from_args
      ARGV.each do |g|
        next unless g[0] == '-' && g[1] == '-'
        add_to_user_choise g[2..-1].to_sym
      end
    end

    def cleanup_comments(file)
      accepted_content = File.readlines(file).reject do |line|
        line =~ /^\s*#.*$/ || line =~ /^$\n/
      end

      File.open(file, 'w') do |f|
        accepted_content.each { |line| f.puts line }
      end
    end

    # does not recognize variable nesting, but now it does not matter
    def cover_def_by(file, lookup_str, external_def)
      expect_end = 0
      found = false
      accepted_content = ''
      File.readlines(file).each do |line|
        expect_end += 1 if found && line =~ /\sdo\s/
        expect_end -= 1 if found && line =~ /(\s+end|^end)/
        if line =~ Regexp.new(lookup_str)
          accepted_content += "#{external_def}\n#{line}"
          expect_end += 1
          found = true
        else
          accepted_content += line
        end
        if found && expect_end == 0
          accepted_content += "\nend"
          found = false
        end
      end
      File.open(file, 'w') do |f|
        f.puts accepted_content
      end
    end

    def install_from_github(_gem_name)
      # TODO: in case of bundler update `bundle show` do now work any more
      true

      # return nil unless gem_name
      # path = `cd #{Dir.pwd} && bundle show #{gem_name}`.chomp
      # run "cd #{path} && bundle exec gem build #{gem_name}.gemspec && bundle exec gem install *.gem"
    end

    def user_choose?(g)
      AppBuilder.user_choice.include? g
    end

    def add_to_user_choise(g)
      AppBuilder.user_choice.push g
    end

    def rails_generator(command)
      bundle_command "exec rails generate #{command}"
    end

    def pgsql_db_exist?(db_name)
      system "psql -l | grep #{db_name}"
    end
  end
end
