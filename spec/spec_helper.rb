# frozen_string_literal: true

require "bundler/setup"
require "webmock/rspec"
require "byebug"
require "iterable_rails"
require_relative "fixtures/models/test_mailer"

ActionMailer::Base.delivery_method = :iterable
ActionMailer::Base.prepend_view_path(File.join(File.dirname(__FILE__), "fixtures", "views"))

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
