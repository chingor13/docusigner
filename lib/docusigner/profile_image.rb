module Docusigner
  class ProfileImage < Docusigner::Base
    belongs_to :profile
    singleton

    self.element_name = "image"
  end
end
