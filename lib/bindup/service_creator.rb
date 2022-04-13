# frozen_string_literal: true

module Bindup
  module ServiceCreator
    class << self
      HTTP_METHOD_BODY_NOT_SUPPORTED = %w[get head trace delete].freeze

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
            build_headers(version_class)
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
          version_class.define_singleton_method("API_ENDPOINT") { service["base_url"] } if service["base_url"].present?
        end

        version_class.define_singleton_method(:set_api_endpoint_by_version) do
          version_class.define_singleton_method("API_ENDPOINT") { version["base_url"] } if version["base_url"].present?
        end
      end

      def faraday_client(version_class)
        version_class.define_singleton_method(:client) do |options:|
          return version_class.send(:build_client, options: options) if options.present?

          @client ||= version_class.send(:build_client)
        end
      end

      def request(version_class)
        version_class.define_singleton_method(:request) do |http_method:, endpoint:, params: nil, headers: nil, options: nil|
          params = version_class.send(:build_params, options, params)
          headers = version_class.send(:build_headers, options, headers)

          response = version_class.send(:client, options: options).send(http_method, endpoint, params, headers)
          [response&.body, response&.headers]
        end
      end

      def log_response_params(version_class)
        version_class.define_singleton_method(:log_response_params) do
          if Bindup.configuration.log_response_params.present?
            Bindup.configuration.log_response_params
          else
            { headers: true, bodies: true }
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
            version_class.send(:request_method_build, api: api, params: params&.stringify_keys, headers: headers&.stringify_keys)
          end
        end
      end

      def build_client(version_class)
        version_class.define_singleton_method(:build_client) do |options:|
          url = options.present? && options["base_url"].present? ? options["base_url"] : version_class.API_ENDPOINT

          Faraday.new(url) do |client|
            client.response :logger, nil, version_class.send(:log_response_params) if Bindup.configuration.log_response
            client.adapter Faraday.default_adapter
          end
        end
      end

      def build_options(version_class)
        version_class.define_singleton_method(:build_options) do |api|
          { "base_url" => api["base_url"], "type" => (api["type"]), "http_method" => api["verb"].downcase }
        end
      end

      def build_params(version_class)
        version_class.define_singleton_method(:build_params) do |options, params|
          return params if params.blank? || options.blank? || options["type"].blank?
          return params if options["http_method"].present? && HTTP_METHOD_BODY_NOT_SUPPORTED.include?(options["http_method"])

          case options["type"].downcase
          when "json"
            params = params.to_json
          when "urlencoded"
            params = URI.encode_www_form(params)
          else
            params
          end

          params
        end
      end

      def build_headers(version_class)
        version_class.define_singleton_method(:build_headers) do |options, headers|
          return headers if options.blank? || options["type"].blank?

          headers = {} if headers.blank?

          case options["type"].downcase
          when "json"
            headers.merge!({ "Content-Type" => "application/json" }) unless headers.key?("Content-Type")
          when "urlencoded"
            headers.merge!({ "Content-Type" => "application/x-www-form-urlencoded" }) unless headers.key?("Content-Type")
          else
            headers
          end

          headers
        end
      end

      def methods_as_private(version_class)
        version_class.private_class_method :log_response_params, :request, :client, :request_method_build,
                                           :set_api_endpoint_by_service, :set_api_endpoint_by_version, :build_client,
                                           :build_options, :build_params, :build_headers
      end
    end
  end
end

