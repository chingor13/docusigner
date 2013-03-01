require 'docusigner/base'
module Docusigner
  autoload :Account, "docusigner/account"
  autoload :BillingPlan, "docusigner/billing_plan"
  autoload :Brand, "docusigner/brand"
  autoload :Document, "docusigner/document"
  autoload :Envelope, "docusigner/envelope"
  autoload :Folder, "docusigner/folder"
  autoload :Group, "docusigner/group"
  autoload :Recipient, "docusigner/recipient"
  autoload :Settings, "docusigner/settings"
  autoload :Tab, "docusigner/tab"
  autoload :Template, "docusigner/template"
  autoload :User, "docusigner/user"
  autoload :Multipart, "docusigner/multipart"

  class << self
    def connection
      Docusigner::Base.connection
    end

    def access_token(username, password, integrator_key)
      connection.post
    end
  end
end

