module Docusigner
  class Envelope < Docusigner::Base
    belongs_to :account

    has_many :documents
    has_many :recipients
    has_many :tabs

    def id
      attributes["envelopeId"]
    end

    def send!
      update_attribute(:status, "sent")
    end

    def void!(reason)
      update_attributes({
        :status => "voided",
        :voidReason => reason
      })
    end

    class << self
      private

      def instantiate_collection(collection, prefix_options = {})
        super(collection["envelopes"], prefix_options)
      end

      def instantiate_record(record, prefix_options = {})
        super(record, prefix_options).tap do |r|
          r.account_id = prefix_options[:account_id]
        end
      end
    end
  end
end
