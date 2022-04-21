require_relative "version"
require_relative "service_creator"
require_relative "configuration"
require "yaml"
require 'active_support/all'
require "faraday"

module Bindup
  extend Bindup::Configuration
end
