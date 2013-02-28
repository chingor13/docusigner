module Docusigner
  class Settings < Docusigner::Base
    singleton

    belongs_to :account

    class << self
      def instantiate_record(record, prefix_options)
        super({
          :accountSettings => record,
          :account_id => prefix_options[:account_id]
        }, prefix_options)
      end
    end
  end
end
