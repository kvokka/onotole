# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Suspend a new project with default configuration' do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_onotole
  end

  let(:secrets_file) { IO.read("#{project_path}/config/secrets.yml") }
  let(:staging_file) { IO.read("#{project_path}/config/environments/staging.rb") }
  let(:ruby_version_file) { IO.read("#{project_path}/.ruby-version") }
  let(:secrets_file) { IO.read("#{project_path}/config/secrets.yml") }
  let(:bin_setup_path) { "#{project_path}/bin/setup" }
  let(:newrelic_file) { IO.read("#{project_path}/config/newrelic.yml") }
  let(:application_rb) { IO.read("#{project_path}/config/application.rb") }
  let(:locales_en_file) { IO.read("#{project_path}/config/locales/en.yml") }
  let(:test_rb) { IO.read("#{project_path}/config/environments/test.rb") }
  let(:development_rb) { IO.read("#{project_path}/config/environments/development.rb") }
  let(:dev_env_file) { IO.read("#{project_path}/config/environments/development.rb") }

  it 'ensures project specs pass' do
    allow(Onotole::AppBuilder).to receive(:prevent_double_usage)
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('0 failures')
      end
    end
  end

  it 'inherits staging config from production' do
    config_stub = 'Rails.application.configure do'
    expect(staging_file).to match(/^require_relative ("|')production("|')/)
    expect(staging_file).to match(/#{config_stub}/), staging_file
  end

  it 'creates .ruby-version from Onotole .ruby-version' do
    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end

  it 'copies dotfiles' do
    %w(.ctags .env).each do |dotfile|
      expect(File).to exist("#{project_path}/#{dotfile}")
    end
  end

  it 'loads secret_key_base from env' do
    expect(secrets_file).to match /secret_key_base: <%= ENV\[('|")#{app_name.upcase}_SECRET_KEY_BASE('|")\] %>/
  end

  it 'adds bin/setup file' do
    expect(File).to exist("#{project_path}/bin/setup")
  end

  it 'makes bin/setup executable' do
    expect(File.stat(bin_setup_path)).to be_executable
  end

  it 'adds support file for action mailer' do
    expect(File).to exist("#{project_path}/spec/support/action_mailer.rb")
  end

  it 'configures capybara-webkit' do
    expect(File).to exist("#{project_path}/spec/support/capybara_webkit.rb")
  end

  it 'adds support file for i18n' do
    expect(File).to exist("#{project_path}/spec/support/i18n.rb")
  end

  # it 'creates good default .hound.yml' do
  #   hound_config_file = IO.read("#{project_path}/.hound.yml")

  #   expect(hound_config_file).to include 'enabled: true'
  # end

  it 'ensures newrelic.yml reads NewRelic license from env' do
    expect(newrelic_file).to match(
      /license_key: "<%= ENV\["NEW_RELIC_LICENSE_KEY"\] %>"/
    )
  end

  it 'records pageviews through Segment if ENV variable set' do
    expect(analytics_partial)
      .to include(%(<% if ENV["SEGMENT_KEY"] %>))
    expect(analytics_partial)
      .to include(%{window.analytics.load("<%= ENV["SEGMENT_KEY"] %>");})
  end

  it 'raises on unpermitted parameters in all environments' do
    expect(application_rb).to match(
      /^\s+config.action_controller.action_on_unpermitted_parameters = :raise/
    )
  end

  it 'adds explicit quiet_assets configuration' do
    expect(application_rb).to match(/^ +config.quiet_assets = true$/)
  end

  it 'raises on missing translations in development and test' do
    %w(development test).each do |environment|
      environment_file = IO.read("#{project_path}/config/environments/#{environment}.rb")
      expect(environment_file).to match(
        /^ +config.action_view.raise_on_missing_translations = true$/
      )
    end
  end

  it 'evaluates en.yml.erb' do
    expect(locales_en_file).to match(/application: #{app_name.humanize}/)
  end

  it 'configs simple_form' do
    expect(File).to exist("#{project_path}/config/initializers/simple_form.rb")
  end

  it 'configs :test email delivery method for development' do
    expect(dev_env_file)
      .to match(/^ +config.action_mailer.delivery_method = :file$/)
  end

  it 'uses APPLICATION_HOST, not HOST in the production config' do
    prod_env_file = IO.read("#{project_path}/config/environments/production.rb")
    expect(prod_env_file).to match /("|')#{app_name.upcase}_APPLICATION_HOST("|')/
    expect(prod_env_file).not_to match(/("|')HOST("|')/)
  end

  # it 'configures language in html element' do
  #   layout_path = '/app/views/layouts/application.html.erb'
  #   layout_file = IO.read("#{project_path}#{layout_path}")
  #   expect(layout_file).to match(/<html lang=("|')en("|')>/)
  # end

  it 'configs active job queue adapter' do
    expect(application_rb).to match(
      /^ +config.active_job.queue_adapter = :delayed_job$/
    )
    expect(test_rb).to match(
      /^ +config.active_job.queue_adapter = :inline$/
    )
  end

  it 'configs bullet gem in development' do
    expect(development_rb).to match /^ +Bullet.enable = true$/
    expect(development_rb).to match /^ +Bullet.bullet_logger = true$/
    expect(development_rb).to match /^ +Bullet.rails_logger = true$/
  end

  it 'configs missing assets to raise in test' do
    expect(test_rb).to match(/^ +config.assets.raise_runtime_errors = true$/)
  end

  it 'adds spring to binstubs' do
    expect(File).to exist("#{project_path}/bin/spring")
    bin_stubs = %w(rake rails rspec)
    bin_stubs.each do |bin_stub|
      expect(IO.read("#{project_path}/bin/#{bin_stub}")).to match(/spring/)
    end
  end

  # TODO
  # Not actual in current init config. I'll test it when I'll
  # write tests for working with flags.
  # it 'removes comments and extra newlines from config files' do
  #   config_files = [
  #     IO.read("#{project_path}/config/application.rb"),
  #     IO.read("#{project_path}/config/environment.rb"),
  #     IO.read("#{project_path}/config/environments/development.rb"),
  #     IO.read("#{project_path}/config/environments/production.rb"),
  #     IO.read("#{project_path}/config/environments/test.rb")
  #   ]

  #   config_files.each do |file|
  #     expect(file).not_to match(/.*\s#.*/)
  #     expect(file).not_to match(/^$\n/)
  #   end
  # end

  it 'copies factories.rb' do
    expect(File).to exist("#{project_path}/spec/factories.rb")
  end

  def app_name
    OnotoleTestHelpers::APP_NAME
  end

  def analytics_partial
    IO.read("#{project_path}/app/views/application/_analytics.html.erb")
  end
end
