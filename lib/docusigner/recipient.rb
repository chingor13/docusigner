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

    class << self
      private

      def instantiate_collection(collection, prefix_options = {})
        flattened = []
        collection.each do |type, recipients|
          recipients.each do |recipient|
            flattened << instantiate_record(recipient.merge(:type => type), prefix_options)
          end if recipients.is_a?(Array)
        end
        flattened
      end

      def instantiate_record(record, prefix_options = {})
        super(record, prefix_options).tap do |r|
          r.account_id = prefix_options[:account_id]
        end
      end
    end
  end
end
