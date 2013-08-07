module Docusigner
  module NoExtensionJsonFormat
    extend ActiveResource::Formats::JsonFormat

    def self.extension
      ""
    end
  end
end
