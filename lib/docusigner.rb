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
  autoload :LoginInformation, "docusigner/login_information"
  autoload :Recipient, "docusigner/recipient"
  autoload :Settings, "docusigner/settings"
  autoload :Tab, "docusigner/tab"
  autoload :Template, "docusigner/template"
  autoload :User, "docusigner/user"

  # other models
  autoload :Oauth2, "docusigner/oauth2"
end
