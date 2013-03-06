require 'test_helper'

class Docusigner::AccountTest < Test::Unit::TestCase

  context "an account" do
    setup do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf.json")
        .to_return(:body => {
          "accountIdGuid" => "1234-asdf",
          "accountName" => "My Account Name",
          "billingPeriodEndDate" => "2013-03-21T07:00:00.0000000Z",
          "billingPeriodEnvelopesAllowed" => "",
          "billingPeriodEnvelopesSent" => "",
          "billingPeriodStartDate" => "2013-02-21T08:00:00.0000000Z",
          "connectPermission" => "full",
          "currencyCode" => "USD",
          "currentPlanId" => "36eb5ca8-ebc0-446b-930c-ee010eb59179",
          "distributorCode" => "DocuSign",
          "docuSignLandingUrl" => "http://www.docusign.com/products/sign_up/buy_now.php",
          "planName" => "DocuSign Demo Plan",
          "planStartDate" => "2013-02-21T14:28:35.0000000Z",
          "suspensionStatus" => ""
        }.to_json)
      @account = Docusigner::Account.find("1234-asdf")
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf.json")
    end

    should "be findable by id" do
      assert_equal("1234-asdf", @account.id)
    end

    should "be able to fetch its brands" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/brands.json")
        .to_return(:body => {
          "brands" => [{
            "brandCompany" => "String content",
            "brandId" => "1",
            "brandName" => "String content",
          }, {
            "brandCompany" => "String content",
            "brandId" => "2",
            "brandName" => "String content",
          }],
          "recipientBrandIdDefault" => "1",
          "senderBrandIdDefault" => "1",
        }.to_json)
      brands = @account.brands
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/brands.json")
      assert_equal(2, brands.length)
      brands.each do |brand|
        assert_equal("1234-asdf", brand.account_id)
      end
    end

    should "be able to fetch a list of custom fields" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/custom_fields.json")
        .to_return(:body => {
          "listCustomFields" => [{
            "name" => "String",
            "required" => "String",
            "show" => "String",
            "listItems" => ["String","String"]
          },
          {
            "name" => "String",
            "required" => "String",
            "show" => "String",
            "listItems" => ["String","String"]
          }],
          "textCustomFields" => [{
            "name" => "String",
            "required" => "String",
            "show" => "String",
          },
          {
            "name" => "String",
            "required" => "String",
            "show" => "String",
          }]
        }.to_json)
      custom_fields = @account.custom_fields
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/custom_fields.json")
      assert_equal(4, custom_fields.length)
      custom_fields.each do |custom_field|
        assert_equal("1234-asdf", custom_field.account_id)
      end
    end

    should "be able to fetch envelopes from a given date" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes.json?from_date=2013-01-01")
        .to_return(:body => {
          "envelopes" => [{
            "certificateUri" => "String content",
            "customFieldsUri" => "String content",
            "documentsCombinedUri" => "String content",
            "documentsUri" => "String content",
            "envelopeId" => "envelope1",
            "envelopeUri" => "String content",
            "notificationUri" => "String content",
            "recipientsUri" => "String content",
            "status" => "created",
            "statusChangedDateTime" => "String content"
          },
          {
            "certificateUri" => "String content",
            "customFieldsUri" => "String content",
            "documentsCombinedUri" => "String content",
            "documentsUri" => "String content",
            "envelopeId" => "envelope2",
            "envelopeUri" => "String content",
            "notificationUri" => "String content",
            "recipientsUri" => "String content",
            "status" => "sent",
            "statusChangedDateTime" => "String content"
          }],
          "resultSetSize" => "String content"
        }.to_json)
      envelopes = @account.envelopes("2013-01-01")
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes.json?from_date=2013-01-01")
      assert_equal(2, envelopes.length)
      envelopes.each do |envelope|
        assert_equal("1234-asdf", envelope.account_id)
      end
    end

    should "be able to fetch folders" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/folders.json")
        .to_return(:body => {
          "folders" => [{
            "folderId" => "String content",
            "name" => "String content",
            "ownerEmail" => "String content",
            "ownerUserName" => "String content",
            "type" => "String content",
            "uri" => "String content"
          },
          {
            "folderId" => "String content",
            "name" => "String content",
            "ownerEmail" => "String content",
            "ownerUserName" => "String content",
            "type" => "String content",
            "uri" => "String content"
          },
          {
            "folderId" => "String content",
            "folders" => [{
              "folderId" => "String content",
              "name" => "String content",
              "ownerEmail" => "String content",
              "ownerUserName" => "String content",
              "parentFolderId" => "String content",
              "parentFolderUri" => "String content",
              "type" => "String content",
              "uri" => "String content"
            }],
          }],
        }.to_json)
      folders = @account.folders
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/folders.json")
      assert_equal(3, folders.length)
      folders.each do |folder|
        assert_equal("1234-asdf", folder.account_id)
      end
    end

    should "be able to fetch groups" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/groups.json")
        .to_return(:body => {
          "groups" => [{
            "groupId" => "String content",
            "groupName" => "String content",
            "groupType" => "String content",
            "permissionsProfileId" => "String content"
          }]
        }.to_json)
      groups = @account.groups
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/groups.json")
      assert_equal(1, groups.length)
      groups.each do |group|
        assert_equal("1234-asdf", group.account_id)
      end
    end

    should "be able to fetch settings" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/settings.json")
        .to_return(:body => {
          "accountSettings" => [
            {
              "name" => "allowInPerson",
              "value" => "true"
            },
            {
              "name" => "allowSignerReassign",
              "value" => "true"
            },
            {
              "name" => "attachCompletedEnvelope",
              "value" => "true"
            },
            {
              "name" => "autoNavRule",
              "value" => "required_fields"
            },
            {
              "name" => "canSelfBrandSend",
              "value" => "true"
            },
            {
              "name" => "canSelfBrandSign",
              "value" => "true"
            },
            {
              "name" => "enableAutoNav",
              "value" => "false"
            },
            {
              "name" => "enableCalculatedFields",
              "value" => "true"
            },
            {
              "name" => "enableDSPro",
              "value" => "false"
            },
            {
              "name" => "enableEnvelopeStampingByAccountAdmin",
              "value" => "false"
            },
            {
              "name" => "enablePaymentProcessing",
              "value" => "false"
            },
            {
              "name" => "enablePowerForm",
              "value" => "true"
            },
            {
              "name" => "enableReservedDomain",
              "value" => "false"
            },
            {
              "name" => "enableSendToAgent",
              "value" => "true"
            },
            {
              "name" => "enableSendToIntermediary",
              "value" => "false"
            },
            {
              "name" => "enableSendToManage",
              "value" => "true"
            },
            {
              "name" => "enableSequentialSigningAPI",
              "value" => "true"
            },
            {
              "name" => "enableSequentialSigningUI",
              "value" => "true"
            },
            {
              "name" => "enableSignerAttachments",
              "value" => "true"
            },
            {
              "name" => "enableSignOnPaper",
              "value" => "true"
            },
            {
              "name" => "enableSignOnPaperOverride",
              "value" => "false"
            },
            {
              "name" => "enableTransactionPoint",
              "value" => "false"
            },
            {
              "name" => "enableVaulting",
              "value" => "false"
            },
            {
              "name" => "envelopeIntegrationAllowed",
              "value" => "full"
            },
            {
              "name" => "envelopeIntegrationEnabled",
              "value" => "false"
            },
            {
              "name" => "envelopeStampingDefaultValue",
              "value" => "false"
            },
            {
              "name" => "idCheckExpire",
              "value" => "always"
            },
            {
              "name" => "idCheckExpireDays",
              "value" => "0"
            },
            {
              "name" => "idCheckRequired",
              "value" => "never"
            },
            {
              "name" => "pkiSignDownloadedPDFDocs",
              "value" => "yes_sign"
            },
            {
              "name" => "signDateFormat",
              "value" => "M/d/yyyy"
            },
            {
              "name" => "signerAttachCertificateToEnvelopePDF",
              "value" => "false"
            },
            {
              "name" => "signerCanCreateAccount",
              "value" => "true"
            },
            {
              "name" => "signerCanSignOnMobile",
              "value" => "true"
            },
            {
              "name" => "signerInSessionUseEnvelopeCompleteEmail",
              "value" => "false"
            },
            {
              "name" => "signerMustHaveAccount",
              "value" => "false"
            },
            {
              "name" => "signerMustLoginToSign",
              "value" => "false"
            },
            {
              "name" => "signerShowSecureFieldInitialValues",
              "value" => "false"
            },
            {
              "name" => "sessionTimeout",
              "value" => "120"
            },
            {
              "name" => "useAccountLevelEmail",
              "value" => "true"
            },
            {
              "name" => "usesAPI",
              "value" => "false"
            }
          ]
        }.to_json)
      settings = @account.settings
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/settings.json")
      assert_equal("false", settings["usesAPI"])
      assert_equal("1234-asdf", settings.account_id)
    end

    should "be able to fetch templates" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/templates.json")
        .to_return(:body => {
          "envelopeTemplates" => [{
            "description" => "String content",
            "folderName" => "String content",
            "folderUri" => "String content",
            "lastModified" => "String content",
            "name" => "String content",
            "pageCount" => 2147483647,
            "password" => "String content",
            "shared" => "String content",
            "templateId" => "String content",
            "uri" => "String content"
          }]
        }.to_json)
      templates = @account.templates
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/templates.json")
      assert_equal(1, templates.length)
      templates.each do |template|
        assert_equal("1234-asdf", template.account_id)
      end
    end

    should "be able to fetch users" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/users.json")
        .to_return(:body => {
          "users" => [{
            "uri" => "String content",
            "userId" => "String content",
            "userName" => "String content",
            "userStatus" => "String content",
            "userType" => "String content"
          }]
        }.to_json)
      users = @account.users
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/users.json")
      assert_equal(1, users.length)
      users.each do |user|
        assert_equal("1234-asdf", user.account_id)
      end
    end
  end

end
