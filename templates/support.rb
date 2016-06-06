# frozen_string_literal: true
Dir[Rails.root.join('app/support/**/*.rb'),
    Rails.root.join('lib/*.rb')].sort.reverse.each { |file| require_dependency file }
