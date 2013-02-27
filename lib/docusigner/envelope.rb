class Docusigner::Envelope < Docusigner::Base
  belongs_to :account

  has_many :documents
  has_many :recipients
  has_many :tabs
end
