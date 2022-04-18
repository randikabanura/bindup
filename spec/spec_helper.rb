# frozen_string_literal: true

require "bindup"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Bindup.configure do |config|
  config.config_path = "./spec/config/config.yml"
  config.log_response = true
  config.log_response_params = { headers: true, bodies: true }
end
