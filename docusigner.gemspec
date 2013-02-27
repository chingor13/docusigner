Gem::Specification.new do |s|
  s.name = "docusigner"
  s.version = "0.0.1"
  s.description = "Unofficial gem for accessing the DocuSign REST API"
  s.summary = "Unofficial gem for accessing the DocuSign REST API"
  s.add_dependency "oauth2"
  s.add_dependency "reactive_resource"
  s.add_dependency "faraday"

  s.author = "Jeff Ching"
  s.email = "jeff@chingr.com"
  s.homepage = "http://github.com/chingor13/docusigner"

  s.files = `git ls-files`.split("\n")
end
