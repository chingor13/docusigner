require 'reactive_resource'
require 'docusigner/multipart'
module Docusigner
  class Base < ReactiveResource::Base
    self.site = "https://demo.docusign.net/restapi/v2"
    self.format = :json
    self.include_root_in_json = false

    # allow you to attach documents
    include Docusigner::Multipart::Resource

    class << self
      # we want to inherit headers for authentication
      def headers
        @headers ||= begin
          superclass.respond_to?(:headers) ? superclass.headers.dup : {}
        end
      end

      def connection(refresh = false)
        if defined?(@connection) || self == Docusigner::Base
          @connection = Docusigner::Connection.new(site, format) if refresh || @connection.nil? || !@connection.is_a?(Docusigner::Connection)
          @connection.timeout = timeout if timeout
          @connection.ssl_options = ssl_options if ssl_options
          @connection
        else
          superclass.connection
        end
      end

      def token=(token)
        headers['Authorization'] = "Bearer #{token}"
      end

      def authorization=(options = {})
        headers['X-DocuSign-Authentication'] = "<DocuSignCredentials><Username>%{username}</Username><Password>%{password}</Password><IntegratorKey>%{integrator_key}</IntegratorKey></DocuSignCredentials>" % options
      end
    end

    # the json should skip the root element
    def to_json(opts = {})
      as_json.to_json
    end

    protected

    # we want any generated resources for generated models to extend from this base class
    #   mainly because we don't want the include the root in the json representation
    def create_resource_for(resource_name)
      resource = self.class.const_set(resource_name, Class.new(Docusigner::Base))
      resource.prefix = self.class.prefix
      resource.site = self.class.site
      resource
    end
  end
end
