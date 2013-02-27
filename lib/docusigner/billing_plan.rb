class Docusigner::BillingPlan < Docusigner::Base
  singleton

  belongs_to :account
end

