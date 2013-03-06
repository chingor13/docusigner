module Docusigner
  class Recipient < Docusigner::Base
    module Status
      CREATED       = "created"
      SENT          = "sent"
      DELIVERED     = "delivered"
      SIGNED        = "signed"
      DECLINED      = "declined"
      COMPLETED     = "completed"
      FAX_PENDING   = "faxpending"
      AUTORESPONDED = "autoresponded"
    end

    belongs_to :envelope
    has_many :tabs
  end
end
