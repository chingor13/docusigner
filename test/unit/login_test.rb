require 'test_helper'

class Docusigner::LoginTest < Test::Unit::TestCase

  should "be able to fetch login information" do
    stub_request(:get, "https://demo.docusign.net/restapi/v2/login_information.json")
      .to_return(:body => {
        "apiPassword" => "base64encoded=",
        "loginAccounts" => [
          {
            "accountId" => "1234",
            "accountIdGuid" => "asdfawef23fwfwef",
            "baseUrl" => "https://demo.docusign.net/restapi/v2/accounts/1234",
            "email" => "myemail@gmail.com",
            "isDefault" => "true",
            "loginAccountSettings" => [
              {
                "name" => "usesAPI",
                "value" => "false"
              }
            ],
            "loginUserSettings" => [
              {
                "name" => "canManageAccount",
                "value" => "true"
              },
              {
                "name" => "canSendAPIRequests",
                "value" => "false"
              },
              {
                "name" => "canSendEnvelope",
                "value" => "true"
              },
              {
                "name" => "allowSendOnBehalfOf",
                "value" => "true"
              },
              {
                "name" => "apiAccountWideAccess",
                "value" => "true"
              }
            ],
            "name" => "Company.com",
            "siteDescription" => "",
            "userId" => "someguid",
            "userName" => "Jeff Ching"
          }
        ]
      }.to_json)
    login_information = Docusigner::LoginInformation.find
    assert_requested(:get, "https://demo.docusign.net/restapi/v2/login_information.json")
    assert_equal(1, login_information.loginAccounts.length)
  end

  should "be able to update password" do
    stub_request(:put, "https://demo.docusign.net/restapi/v2/login_information/password.json")
      .with(:body => {
        :currentPassword => "oldpw",
        :email => "myemail@gmail.com",
        :newPassword => "newpw"
      }.to_json)
    Docusigner::LoginInformation.change_password("myemail@gmail.com", "oldpw", "newpw")
    assert_requested(:put, "https://demo.docusign.net/restapi/v2/login_information/password.json")
  end
end
