require 'rubygems'
require 'test/unit'
require 'docusigner'
require 'shoulda'
require 'webmock/test_unit'

class Test::Unit::TestCase
  include WebMock::API
end

WebMock.disable_net_connect!
