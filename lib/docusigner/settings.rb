module Docusigner
  class Settings < Docusigner::Base
    singleton

    belongs_to :account

    def [](setting)
      as = accountSettings.detect{|as| as.name == setting}
      as ? as.attributes["value"] : nil
    end

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
