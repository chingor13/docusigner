module Docusigner
  class ProfileImage < Docusigner::Base
    belongs_to :profile
    singleton
    self.format = Docusigner::WithRootJsonFormat

    self.element_name = "image"
  end
end
