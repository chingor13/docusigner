module Docusigner
  module WithRootJsonFormat
    extend ActiveResource::Formats::JsonFormat

    def self.decode(json)
      ActiveSupport::JSON.decode(json)
    end
  end
end
