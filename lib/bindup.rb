# frozen_string_literal: true

require_relative "bindup/version"
require_relative 'bindup/service_creator'
require 'yaml'


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