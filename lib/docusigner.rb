require 'docusigner/base'
module Docusigner
  # extensions
  autoload :Connection, "docusigner/connection"
  autoload :Multipart, "docusigner/multipart"

  # REST models
  autoload :Account, "docusigner/account"
  autoload :BillingPlan, "docusigner/billing_plan"
  autoload :Brand, "docusigner/brand"
  autoload :CustomField, "docusigner/custom_field"
  autoload :Document, "docusigner/document"
  autoload :Envelope, "docusigner/envelope"
  autoload :Folder, "docusigner/folder"
  autoload :Group, "docusigner/group"
  autoload :Recipient, "docusigner/recipient"
  autoload :Settings, "docusigner/settings"
  autoload :Tab, "docusigner/tab"
  autoload :Template, "docusigner/template"
  autoload :User, "docusigner/user"

  class << self
    def connection
      Docusigner::Base.connection
    end

    def access_token(username, password, integrator_key)
      connection.post
    end
  end
end
