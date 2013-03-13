module Docusigner
  class Profile < Docusigner::Base
    belongs_to :user
    has_one :image, :class_name => "Docusigner::ProfileImage"
    singleton
  end
end
