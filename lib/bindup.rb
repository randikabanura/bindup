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
    attr_accessor :config_path

    def initialize
      @config_path = "config/initializer/bindup.yml"
    end
  end
end