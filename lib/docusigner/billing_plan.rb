module Docusigner
  class BillingPlan < Docusigner::Base
    singleton

    belongs_to :account
  end
end

