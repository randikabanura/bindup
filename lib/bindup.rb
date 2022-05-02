# frozen_string_literal: true

require_relative "bindup/version"
require_relative 'bindup/service_creator'
require 'yaml'

# Bindup is customizable API wrapper
#
# It is able to wrap API from other services so the Ruby application
# use those API with out having to implement a new module to deal with
# every single API or having to create a gem. Bindup will be able to
# setup multiple services at once so that integrating whole new service
# is easy as changing the config
module Bindup

  class << self
    attr_accessor :configuration
    attr_reader :component_setup
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)

    @component_setup = YAML.load_file(configuration.config_path)

    Bindup::ServiceCreator.execute
  end

  class Configuration
    attr_accessor :config_path, :log_response, :log_response_params

    def initialize
      @config_path = "config/initializer/bindup.yml"
      @log_response = true
      # { headers: true, bodies: true }
      @log_response_params = nil
    end
  end
end
