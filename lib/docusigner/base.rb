class Docusigner::Base < ReactiveResource::Base
  self.site = "https://demo.docusign.net/restapi/v2/"
  self.format = :json
end
