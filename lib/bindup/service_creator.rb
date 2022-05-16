# frozen_string_literal: true

require "faraday"

module Bindup
  module ServiceCreator
    class << self
      def execute
        services = Bindup.component_setup["components"].keys
        components = Bindup.component_setup["components"]
        log_response_params = if Bindup.configuration.log_response_params.nil?
                                { headers: true, bodies: true }
                              else
                                Bindup.configuration.log_response_params
                              end

        services.each do |service|
          versions = components[service]["version"]

          service_module = Bindup.const_set(components[service]["name"], Module.new)
          versions.each do |version|
            version_class = service_module.const_set(version["name"], Class.new)
            version_class.define_singleton_method("API_ENDPOINT") { service["base_url"] } unless service["base_url"].nil?
            version_class.define_singleton_method("API_ENDPOINT") { version["base_url"] } unless version["base_url"].nil?

            version["apis"].each do |api|
              version_class.define_singleton_method(api["name"].to_sym) do |params: nil, headers: nil|
                version_class.send(:request, http_method: api["verb"].downcase.to_sym, endpoint: api["url"],
                                   params: params, headers: headers)
              end
            end

            private

            version_class.define_singleton_method(:client) do
              Faraday.new(version_class.API_ENDPOINT) do |client|
                client.response :logger, nil, log_response_params if Bindup.configuration.log_response
                client.adapter Faraday.default_adapter
              end
            end

            version_class.define_singleton_method(:request) do |http_method:, endpoint:, params: nil, headers: nil|
              version_class.public_send(:client).public_send(http_method, endpoint, params, headers)
            end
          end
        end
      end
    end
  end
end

