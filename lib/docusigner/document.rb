module Docusigner
  class Document < Docusigner::Base
    belongs_to :envelope
  end
end
