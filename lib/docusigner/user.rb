module Docusigner
  class User < Docusigner::Base
    belongs_to :account

    # DocuSign does not permit this endpoint
    def update
      raise "Not permitted"
    end

    # the create endpoint requires attributes to be nested under newUsers
    def as_json
      { "newUsers" => [super] }
    end

    protected

    def id_from_response(response)
      json = JSON.parse(response.body)
      json["newUsers"].first["userId"]
    end

    def load(attributes, remove_root = false)
      if attributes.is_a?(Array)
        attributes = attributes.first
      end
      super(attributes, remove_root)
    end
  end
end
