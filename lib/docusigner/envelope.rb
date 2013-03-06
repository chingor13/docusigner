module Docusigner
  class Envelope < Docusigner::Base
    module Status
      CREATED   = "created"
      DELETED   = "deleted"
      SENT      = "sent"
      DELIVERED = "delivered"
      SIGNED    = "signed"
      COMPLETED = "completed"
      DECLINED  = "declined"
      VOIDED    = "voided"
      TIMED_OUT = "timedout"
      AUTHORITATIVE_COPY  = "authoritativecopy"
      TRANSFER_COMPLETED  = "transfercompleted"
      TEMPLATE  = "template"
      CORRECT   = "correct"
    end

    belongs_to :account

    has_many :documents
    has_many :recipients

    def id
      attributes["envelopeId"]
    end

    def send!
      update_attribute(:status, Docusigner::Envelope::Status::SENT)
    end

    def void!(reason)
      update_attributes({
        :status => Docusigner::Envelope::Status::VOIDED,
        :voidReason => reason
      })
    end

    def recipient_url(params = {})
      resp = post("views/recipient", prefix_options, params.to_json)
      self.class.format.decode(resp.body)
    end

    def sender_url(params = {})
      resp = post("views/sender", prefix_options, params.to_json)
      self.class.format.decode(resp.body)
    end

    def correct_url(params = {})
      resp = post("views/correct", prefix_options, params.to_json)
      self.class.format.decode(resp.body)
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
