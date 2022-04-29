# frozen_string_literal: true

require_relative "bindup/version"
require_relative "bindup/service_creator"
require_relative "bindup/configuration"
require "yaml"

# Bindup is customizable API wrapper
#
# It is able to wrap API from other services so the Ruby application
# use those API with out having to implement a new module to deal with
# every single API or having to create a gem. Bindup will be able to
# setup multiple services at once so that integrating whole new service
# is easy as changing the config
module Bindup
  extend Configuration
end
