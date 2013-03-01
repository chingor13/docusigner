require 'reactive_resource'
require 'docusigner/multipart'
module Docusigner
  class Base < ReactiveResource::Base
    self.site = "https://demo.docusign.net/restapi/v2"
    self.format = :json
    self.include_root_in_json = false

    # allow you to attach documents
    include Docusigner::Multipart::Resource

    def self.token=(token)
      connection.send(:default_header)['Authorization'] = "Bearer #{token}"
    end
    def self.authorization=(options = {})
      if options[:token]
        self.token = options[:token]
      else
        header = %(<DocuSignCredentials><Username>%{name}</Username><Password>%{password}</Password><IntegratorKey>%{integrator_key}</IntegratorKey></DocuSignCredentials>)
        connection.send(:default_header)['X-DocuSign-Authentication'] = header % options
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
