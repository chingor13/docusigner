module Docusigner
  module NoExtensionJsonFormat
    extend ActiveResource::Formats::JsonFormat

    def self.extension
      ""
    end

    def self.decode(data)
      super(data)
    end
  end
end
