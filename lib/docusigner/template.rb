require 'net/http/post/multipart'

module Docusigner
  class Template < Docusigner::Base
    include Docusigner::Multipart::Resource
    belongs_to :account
  end
end
