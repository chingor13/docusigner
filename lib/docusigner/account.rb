module Docusigner
  class Account < Docusigner::Base
    attr_accessor :id

    has_one :billing_plan
    has_one :settings, :class_name => "Docusigner::Settings"

    has_many :brands
    has_many :custom_fields

    # define this manually because the index action requires a from_date
    def envelopes(from_date, options = {})
      Docusigner::Envelope.find(:all, :params => options.reverse_merge({:account_id => id, :from_date => from_date}))
    end

    has_many :folders
    has_many :groups
    has_many :templates
    has_many :users

    def self.find_single(id, options)
      super(id, options).tap do |r|
        r.id = id
      end
    end
  end
end
