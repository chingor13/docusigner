class Docusigner::Account < Docusigner::Base
  has_one :billing_plan
  has_many :brands
  has_many :envelopes
  has_many :folders
  has_many :groups
  has_many :templates
  has_many :users
end

