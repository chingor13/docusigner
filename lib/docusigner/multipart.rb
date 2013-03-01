require 'net/http/post/multipart'

# this class leverages some parts of the multipart-post gem,
#   but we need to change some headers
module Docusigner
  module Multipart
    module Multipartable
      DEFAULT_BOUNDARY = "-----------RubyMultipartPost"
      def initialize(path, params, headers={}, opts = {})
        boundary = opts[:boundary] || DEFAULT_BOUNDARY
        super(path, headers)
        parts = params.map {|v| Docusigner::Multipart::Parts.build(boundary, v, opts)}
        parts << ::Parts::EpiloguePart.new(boundary)
        ios = parts.map{|p| p.to_io }
        self.set_content_type("multipart/form-data", { "boundary" => boundary })
        self.content_length = parts.inject(0) {|sum,i| sum + i.length }
        self.body_stream = CompositeReadIO.new(*ios)
      end
    end

    module Parts
      def self.build(boundary, value, opts = {})
        if value.is_a?(Array)
          self.build(boundary, value.first, opts.merge(value.last))
        elsif value.is_a?(String)
          DataPart.new(boundary, value, opts)
        elsif value.is_a?(UploadIO)
          DocumentPart.new(boundary, value, opts)
        else
          DataPart.new(boundary, value, opts)
        end
      end

      class DataPart < StringIO
        def initialize(boundary, data, opts = {})
          @format = opts[:format] || :json
          @content_type = {
            :json => "application/json",
            :xml => "application/xml"
          }[@format]
          super(build(boundary, data, opts))
        end
        def to_io
          self
        end
        protected
        def build(boundary, value, opts = {})
          [
            "--#{boundary}",
            "Content-Type: #{@content_type}",
            "Content-Disposition: form-data",
            "",
            value,
            ""
          ].join("\r\n")
        end
      end

      class DocumentPart
        attr_reader :length
        def initialize(boundary, upload_io, opts = {})
          @upload_io = upload_io
          head = build(boundary, @upload_io, opts)
          foot = "\r\n"
          @output_io = CompositeReadIO.new(StringIO.new(head), @upload_io.io, StringIO.new(foot))
          @length = head.length + file_length + foot.length
        end
        def to_io
          @output_io
        end
        protected

        def file_length
          @file_length ||= @upload_io.respond_to?(:length) ? @upload_io.length : File.size(@upload_io.local_path)
        end
        
        def build(boundary, io, opts = {})
          [
            "--#{boundary}",
            %(Content-Type: #{io.content_type}),
            %(Content-Disposition: file; filename="#{opts[:name]}"; documentId=#{opts[:document_id]}),
            %(Content-Length: #{file_length}),
            "",
            ""
          ].join("\r\n")
        end
      end
    end

    class Post < Net::HTTP::Post
      include Docusigner::Multipart::Multipartable
    end

    class Put < Net::HTTP::Put
      include Docusigner::Multipart::Multipartable
    end

    module Resource
      def add_document(file, document_id)
        @documents ||= []
        @documents << [file, {:document_id => document_id}]
      end

      def encode
        if documents.present?
          [super, *documents]
        else
          super
        end
      end

      protected

      def documents
        @documents ||= []
      end
    end

    module ConnectionExtension
      def self.included(klass)
        klass.send(:alias_method_chain, :post, :multipart)
        klass.send(:alias_method_chain, :put, :multipart)
      end

      def post_with_multipart(path, body = '', headers = {})
        if body.is_a?(Array)
          with_auth do
            req = Docusigner::Multipart::Post.new(path, body, build_request_headers(headers, :post, self.site.merge(path)))
            handle_response(http.request(req))
          end
        else
          post_without_multipart(path, body, headers)
        end
      end

      def put_with_multipart(path, body = '', headers = {})
        if body.is_a?(Array)
          req = Docusigner::Multipart::Put.new(path, body, headers)
          with_auth { request(:request, req, build_request_headers(headers, :put, self.site.merge(path))) }
        else
          post_without_multipart(path, body, headers)
        end
      end
    end
  end
end

ActiveResource::Connection.send(:include, Docusigner::Multipart::ConnectionExtension)
