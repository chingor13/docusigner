module Docusigner
  class CustomField < Docusigner::Base
    belongs_to :account
  end
end
