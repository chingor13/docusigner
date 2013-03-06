require 'test_helper'

class Docusigner::OauthTest < Test::Unit::TestCase

  should "be able to fetch an OAuth token with username/password/integrator key" do
    stub_request(:post, "https://demo.docusign.net/restapi/v2/oauth2/token.json")
      .with(:body => {"client_id"=>"mykey", "grant_type"=>"password", "password"=>"mypassword", "scope"=>"api", "username"=>"myname"})
      .to_return(:body => {
        "access_token" => "myoauthtoken",
        "scope" => "api",
        "token_type" => "bearer"
      }.to_json)
    token = Docusigner::Oauth2.token("myname", "mypassword", "mykey")
    assert_requested(:post, "https://demo.docusign.net/restapi/v2/oauth2/token.json")
    assert_equal("myoauthtoken", token)
  end

  should "be able to revoke an OAuth token" do
    stub_request(:post, "https://demo.docusign.net/restapi/v2/oauth2/revoke.json")
      .with(:headers => {"Authorization" => "Bearer mytoken"})
      .to_return(:body => "")
    Docusigner::Oauth2.revoke("mytoken")
    assert_requested(:post, "https://demo.docusign.net/restapi/v2/oauth2/revoke.json")
  end

end
