require 'test_helper'

class Docusigner::BaseTest < Test::Unit::TestCase

  context "headers" do
    teardown do
      Docusigner::Base.instance_variable_set(:@headers, nil)
      Docusigner::Account.instance_variable_set(:@headers, nil)
    end

    should "be inheritable" do
      Docusigner::Base.headers['X-Foo'] = "bar"
      assert_equal('bar', Docusigner::Account.headers['X-Foo'])

      Docusigner::Account.headers["X-Bar"] = "foo"
      assert_nil(Docusigner::Base.headers["X-Bar"])
    end

    should "authenticate via a bearer token" do
      Docusigner::Base.token = "sometoken"
      assert_equal("Bearer sometoken", Docusigner::Base.headers['Authorization'])
    end

    should "authenticate via username, password, integrator_key" do
      Docusigner::Base.authorization = {
        :username => "Jeff",
        :password => "supersecure",
        :integrator_key => "longkey",
      }
      assert_equal("<DocuSignCredentials><Username>Jeff</Username><Password>supersecure</Password><IntegratorKey>longkey</IntegratorKey></DocuSignCredentials>", 
        Docusigner::Base.headers['X-DocuSign-Authentication'])
    end
  end

end
