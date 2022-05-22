# frozen_string_literal: true

require "faraday"

module Bindup
  module ServiceCreator
    class << self
      def execute
        services = component_setup_keys
        components = component_setup

        services.each do |service|
          versions = components[service]["version"]
          service_module = create_service_module(components, service)

          versions.each do |version|
            version_class = create_version_class(service_module, version)

            api_endpoint(version_class, service, version)
            faraday_client(version_class)
            request(version_class)
            log_response_params(version_class)
            request_method_build(version_class)

            version_class.send(:set_api_endpoint_by_service)
            version_class.send(:set_api_endpoint_by_version)

            build_options(version_class)
            build_client(version_class)
            build_params(version_class)
            api_methods(version_class, version)
            methods_as_private(version_class)
          end
        end
      end

      private

      def component_setup_keys
        Bindup.component_setup["components"].keys || []
      end

      def component_setup
        Bindup.component_setup["components"]
      end

      def create_service_module(components, service)
        Bindup.const_set(components[service]["name"], Module.new)
      end

      def create_version_class(service_module, version)
        service_module.const_set(version["name"], Class.new)
      end

      def api_endpoint(version_class, service, version)
        version_class.define_singleton_method(:set_api_endpoint_by_service) do
          version_class.define_singleton_method("API_ENDPOINT") { service["base_url"] } unless service["base_url"].nil?
        end

        version_class.define_singleton_method(:set_api_endpoint_by_version) do
          version_class.define_singleton_method("API_ENDPOINT") { version["base_url"] } unless version["base_url"].nil?
        end
      end

      def faraday_client(version_class)
        version_class.define_singleton_method(:client) do |options:|
          return version_class.send(:build_client, options: options) unless options.nil?

          @client ||= version_class.send(:build_client)
        end
      end

      def request(version_class)
        version_class.define_singleton_method(:request) do |http_method:, endpoint:, params: nil, headers: nil, options: nil|
          params = version_class.send(:build_params, options, params)

          response = version_class.send(:client, options: options).send(http_method, endpoint, params, headers)
          [response&.body, response&.headers]
        end
      end

      def log_response_params(version_class)
        version_class.define_singleton_method(:log_response_params) do
          if Bindup.configuration.log_response_params.nil?
            { headers: true, bodies: true }
          else
            Bindup.configuration.log_response_params
          end
        end
      end

      def request_method_build(version_class)
        version_class.define_singleton_method(:request_method_build) do |api:, params: nil, headers: nil|
          options = version_class.send(:build_options, api)
          version_class.send(:request, http_method: api["verb"].downcase.to_sym, endpoint: api["url"],
                                       params: params, headers: headers, options: options)
        end
      end

      def api_methods(version_class, version)
        version["apis"].each do |api|
          version_class.define_singleton_method(api["name"].to_sym) do |params: nil, headers: nil|
            version_class.send(:request_method_build, api: api, params: params, headers: headers)
          end
        end
      end

      def build_client(version_class)
        version_class.define_singleton_method(:build_client) do |options:|
          url = options.nil? || options["base_url"].nil? ? version_class.API_ENDPOINT : options["base_url"]

          Faraday.new(url) do |client|
            client.response :logger, nil, version_class.send(:log_response_params) if Bindup.configuration.log_response
            client.adapter Faraday.default_adapter
          end
        end
      end

      def build_options(version_class)
        version_class.define_singleton_method(:build_options) do |api|
          { "base_url" => api["base_url"], "type" => (api["type"]) }
        end
      end

      def build_params(version_class)
        version_class.define_singleton_method(:build_params) do |options, params|
          case options["type"].downcase
          when "json"
            params.to_json
          when "urlencoded"
            URI.encode_www_form(params)
          else
            params
          end
        end
      end

      def methods_as_private(version_class)
        version_class.private_class_method :log_response_params, :request, :client, :request_method_build,
                                           :set_api_endpoint_by_service, :set_api_endpoint_by_version, :build_client,
                                           :build_options, :build_params
      end
    end
  end
end

