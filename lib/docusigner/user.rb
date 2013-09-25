module Docusigner
  class User < Docusigner::Base
    belongs_to :account
    has_one :profile
    has_one :settings, :class_name => "Docusigner::UserSettings"

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

    def load(*attrs)
      if attrs.first.is_a?(Array)
        attrs[0] = attrs.first.first
      end
      super(*attrs)
    end
  end
end
