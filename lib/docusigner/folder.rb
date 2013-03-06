module Docusigner
  class Folder < Docusigner::Base
    belongs_to :account
  end
end
