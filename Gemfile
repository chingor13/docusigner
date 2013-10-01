source 'http://rubygems.org'
gemspec
gem 'rake'

rails_version = ENV["RAILS_VERSION"] || "default"

rails = case rails_version
when "default"
  ">= 3.2.0"
else
  "~> #{rails_version}"
end

gem "activeresource", rails
