module Docusigner
  class Group < Docusigner::Base
    belongs_to :account
  end
end
