# frozen_string_literal: true

module Bindup
  module ServiceCreator
    extend Bindup::ServiceMethods

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
            build_headers(version_class)
            api_methods(version_class, version)
            methods_as_private(version_class)
          end
        end
      end
    end
  end
end

