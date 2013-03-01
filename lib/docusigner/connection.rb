module Docusigner
  class Connection < ActiveResource::Connection
    def post(path, body = '', headers = {})
      if body.is_a?(Array)
        with_auth do
          req = Docusigner::Multipart::Post.new(path, body, build_request_headers(headers, :post, self.site.merge(path)))
          handle_response(http.request(req))
        end
      else
        super(path, body, headers)
      end
    end

    def put(path, body = '', headers = {})
      if body.is_a?(Array)
        req = Docusigner::Multipart::Put.new(path, body, headers)
        with_auth { request(:request, req, build_request_headers(headers, :put, self.site.merge(path))) }
      else
        super(path, body, headers)
      end
    end
  end
end

