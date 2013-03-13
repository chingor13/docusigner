Gem::Specification.new do |s|
  s.name = "docusigner"
  s.version = "0.0.2"
  s.description = "Unofficial gem for accessing the DocuSign REST API"
  s.summary = "Unofficial gem for accessing the DocuSign REST API"
  s.add_dependency "reactive_resource", ">= 0.7.3"
  s.add_dependency "multipart-post"

  s.add_development_dependency "shoulda"
  s.add_development_dependency "webmock"

  s.author = "Jeff Ching"
  s.email = "jeff@chingr.com"
  s.homepage = "http://github.com/chingor13/docusigner"

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
