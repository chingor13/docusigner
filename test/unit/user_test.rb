require 'test_helper'

class Docusigner::UserTest < Test::Unit::TestCase

  context "an existing user" do
    setup do
      @user = Docusigner::User.new({
        :id => 'qwer123',
        :account_id => '1234-asdf'
      })
    end

    should "be able to fetch profile information including the image" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/users/qwer123/profile.json")
        .to_return(:body => {
          "address" => {
            "address1" => "String content",
            "address2" => "String content",
            "city" => "String content",
            "country" => "String content",
            "fax" => "String content",
            "phone" => "String content",
            "postalCode" => "String content",
            "stateOrProvince" => "String content"
          },
          "authenticationMethods" => [{
            "authenticationType" => "String content",
            "lastProvider" => "String content",
            "lastTimestamp" => "String content",
            "totalCount" => 2147483647
          }],
          "companyName" => "String content",
          "displayOrganizationInfo" => "String content",
          "displayPersonalInfo" => "String content",
          "displayProfile" => "String content",
          "displayUsageHistory" => "String content",
          "title" => "String content",
          "usageHistory" => {
            "lastSentDateTime" => "String content",
            "lastSignedDateTime" => "String content",
            "sentCount" => 2147483647,
            "signedCount" => 2147483647
          },
          "userDetails" => {
            "firstName" => "String content",
            "lastName" => "String content",
            "middleName" => "String content",
            "suffixName" => "String content",
            "title" => "String content",
          }
        }.to_json)
      profile = @user.profile
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/users/qwer123/profile.json")

      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/users/qwer123/profile/image.json")
        .to_return(:body => {
          "url" => "http://someurl.com/"
        }.to_json)
      image = profile.image
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/users/qwer123/profile/image.json")
    end
  end

end
