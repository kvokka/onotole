# frozen_string_literal: true
Capybara.javascript_driver = :webkit

Capybara::Webkit.configure(&:block_unknown_urls)
