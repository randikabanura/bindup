module Bindup
  module ServiceMethods
    METHODS_WITH_QUERY = %w[get head delete trace].freeze
    METHODS_WITH_BODY = %w[post put patch].freeze

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
        extra_params = if METHODS_WITH_QUERY.include?(http_method.to_s)
                         version_class.send(:build_body, options, options["extra_params"], force_build: true)
                       else
                         options["extra_params"]
                       end

        if extra_params.present? && METHODS_WITH_QUERY.include?(http_method.to_s)
          response = version_class.send(:client, options: options).send(http_method, endpoint, params, headers) { |req| req.body = extra_params }
        elsif extra_params.present? && METHODS_WITH_BODY.include?(http_method.to_s)
          response = version_class.send(:client, options: options).send(http_method, endpoint, params, headers) do |req|
            extra_params.each { |extra_params_key, extra_params_value| req.params[extra_params_key.to_s] = extra_params_value }
          end
        else
          response = version_class.send(:client, options: options).send(http_method, endpoint, params, headers)
        end
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
      version_class.define_singleton_method(:request_method_build) do |api:, params: nil, headers: nil, extra_params: nil|
        options = version_class.send(:build_options, api, extra_params)

        version_class.send(:request, http_method: api["verb"].downcase.to_sym, endpoint: api["url"],
                                     params: params, headers: headers, options: options)
      end
    end

    def api_methods(version_class, version)
      version["apis"].each do |api|
        version_class.define_singleton_method(api["name"].to_sym) do |params = nil, headers = nil, extra_params: nil|
          version_class.send(:request_method_build, api: api, params: params&.stringify_keys, headers: headers&.stringify_keys, extra_params: extra_params&.stringify_keys)
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
      version_class.define_singleton_method(:build_options) do |api, extra_params|
        { "base_url" => api["base_url"], "type" => api["type"], "http_method" => api["verb"].downcase, "extra_params" => extra_params }
      end
    end

    def build_params(version_class)
      version_class.define_singleton_method(:build_params) do |options, params, force_build: false|
        return params if params.blank? || options.blank? || options["type"].blank?
        if !force_build && options["http_method"].present? && METHODS_WITH_QUERY.include?(options["http_method"])
          return params
        end

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

    def methods_as_alias(version_class)
      version_class.define_singleton_method(:build_body) do |options, params, force_build: false|
        version_class.send(:build_params, options, params, force_build: force_build)
      end
    end

    def methods_as_private(version_class)
      version_class.private_class_method :log_response_params, :request, :client, :request_method_build,
                                         :set_api_endpoint_by_service, :set_api_endpoint_by_version, :build_client,
                                         :build_options, :build_params, :build_headers
    end
  end
end

