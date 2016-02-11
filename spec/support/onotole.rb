# frozen_string_literal: true
module OnotoleTestHelpers
  APP_NAME = 'dummy_app'

  def remove_project_directory
    FileUtils.rm_rf(project_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def run_onotole(arguments = nil)
    # unless !pgsql_db_exist?("#{APP_NAME}_development") || !pgsql_db_exist?("#{APP_NAME}_test")
    #   allow(STDIN).to receive(:gets) { 'Y' }
    # end
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        add_fakes_to_path
        `
          #{onotole_bin} #{APP_NAME} #{arguments}
        `
      end
    end
  end

  def drop_dummy_database
    if File.exist?(project_path)
      Dir.chdir(project_path) do
        Bundler.with_clean_env do
          `rake db:drop`
        end
      end
    end
  end

  def add_fakes_to_path
    ENV['PATH'] = "#{support_bin}:#{ENV['PATH']}"
  end

  def project_path
    @project_path ||= Pathname.new("#{tmp_path}/#{APP_NAME}")
  end

  private

    def tmp_path
      @tmp_path ||= Pathname.new("#{root_path}/tmp")
    end

    def onotole_bin
      File.join(root_path, 'bin', 'onotole')
    end

    def support_bin
      File.join(root_path, 'spec', 'fakes', 'bin')
    end

    def root_path
      File.expand_path('../../../', __FILE__)
    end

    def pgsql_db_exist?(db_name)
      system "psql -l | grep #{db_name}"
    end
end
