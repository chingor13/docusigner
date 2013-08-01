module Docusigner
  module Format
    extend ActiveResource::Formats::JsonFormat

    def self.extension
      ""
    end
  end
end
