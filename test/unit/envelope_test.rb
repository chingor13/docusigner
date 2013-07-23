require 'test_helper'

class Docusigner::EnvelopeTest < Test::Unit::TestCase

  should "be able to create an envelope" do
    @envelope = Docusigner::Envelope.new({
      :account_id => "1234-asdf",
      :emailSubject => "Fee Agreement",
      :emailBlurb => "Please sign the attached agreement.",
      :recipients => {
        :signers => [
          {
            :email => "someone@somewhere.com",
            :name => "Bob Smith",
            :recipientId => "1",
          }
        ]
      },
      :documents => [
        {
          :name => "Fee Agreement.pdf",
          :documentId => "1"
        }
      ],
      :status => Docusigner::Envelope::Status::SENT
    })
    @envelope.add_document(File.open(File.expand_path("../../test.pdf", __FILE__)), 1)

    stub_request(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes.json")
      .to_return(:body => {
        "envelopeId" => "someid",
        "status" => "sent",
        "statusDateTime" => "2013-02-21T14:28:35.0000000Z",
        "uri" => "/envelopes/someid"
      }.to_json)
    @envelope.save
    assert_requested(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes.json")
    assert_equal("someid", @envelope.id)
  end

  context "an existing envelope" do
    setup do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890.json")
        .to_return(:body => {
          "allowReassign" => "true",
          "certificateUri" => "/envelopes/qwer-7890/documents/certificate",
          "createdDateTime" => "2013-02-26T21:07:46.8430000Z",
          "customFieldsUri" => "/envelopes/qwer-7890/custom_fields",
          "documentsCombinedUri" => "/envelopes/qwer-7890/documents/combined",
          "documentsUri" => "/envelopes/qwer-7890/documents",
          "emailBlurb" => "This is the blurb for the email.",
          "emailSubject" => "SDK Example",
          "enableWetSign" => "true",
          "envelopeId" => "qwer-7890",
          "envelopeUri" => "/envelopes/qwer-7890",
          "notificationUri" => "/envelopes/qwer-7890/notification",
          "recipientsUri" => "/envelopes/qwer-7890/recipients",
          "sentDateTime" => "2013-02-26T21:07:47.1230000Z",
          "status" => "sent",
          "statusChangedDateTime" => "2013-02-26T21:07:47.1230000Z",
          "templatesUri" => "/envelopes/qwer-7890/templates"
        }.to_json)
      @envelope = Docusigner::Envelope.find("qwer-7890", :params => {:account_id => "1234-asdf"})
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890.json")
    end

    should "be findable by id" do
      assert_equal("qwer-7890", @envelope.id)
      assert_equal("1234-asdf", @envelope.account_id)
    end

    should "be able to list recipients" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/recipients.json")
        .to_return(:body => {
          "agents" => [],
          "carbonCopies" => [],
          "certifiedDeliveries" => [],
          "currentRoutingOrder" => "1",
          "editors" => [],
          "inPersonSigners" => [],
          "intermediaries" => [],
          "recipientCount" => "1",
          "signers" => [
            {
              "recipientId" => "1",
              "requireIdLookup" => "false",
              "routingOrder" => "1",
              "status" => "sent",
              "email" => "david@avvo.com",
              "name" => "David Doan"
            }
          ]
        }.to_json)
      recipients = @envelope.recipients
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/recipients.json")
      assert_equal(1, recipients.count)
    end

    should "be able to get a recipient view url" do
      stub_request(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/views/recipient.json")
        .to_return(:body => {
          "url" => "http://localhost/Member/StartInSession.aspx?t=d1cf42f2-30b6-499b-ab54-058fbf438103"
        }.to_json)
      url = @envelope.recipient_url({
        :authenticationMethod => "email",
        :email => "mike.rosey@docusign.com",
        :returnUrl => "http://www.docusign.com",
        :userName => "Mike Rosey",
        :clientUserId => 333,
        :recipientId => 1
      })

      assert_requested(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/views/recipient.json")
      assert_equal("http://localhost/Member/StartInSession.aspx?t=d1cf42f2-30b6-499b-ab54-058fbf438103", url)
    end

    should "be able to get recipient view url using the class method" do
      stub_request(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/views/recipient.json")
        .to_return(:body => {
          "url" => "http://localhost/Member/StartInSession.aspx?t=d1cf42f2-30b6-499b-ab54-058fbf438103"
        }.to_json)

      params = {
        :authenticationMethod => "email",
        :email => "mike.rosey@docusign.com",
        :returnUrl => "http://www.docusign.com",
        :userName => "Mike Rosey",
        :clientUserId => 333,
        :recipientId => 1
      }

      url = Docusigner::Envelope.recipient_url(@envelope.id, @envelope.prefix_options, params)
      assert_requested(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/views/recipient.json")
      assert_equal("http://localhost/Member/StartInSession.aspx?t=d1cf42f2-30b6-499b-ab54-058fbf438103", url)
    end

    should "be able to get a sender view url" do
      stub_request(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/views/sender.json")
        .to_return(:body => {
          "url" => "http://localhost/Member/StartInSession.aspx?StartConsole=1&t=6cafaeaa-cc6b-496d-812d-421b72f854de&DocuEnvelope=AB52A90E-BDC7-4F59-BFBD-90E32E984EA7&send=1"
        }.to_json)
      url = @envelope.sender_url({
        :returnUrl => "http://www.docusign.com",
      })
      assert_requested(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/views/sender.json")
      assert_equal("http://localhost/Member/StartInSession.aspx?StartConsole=1&t=6cafaeaa-cc6b-496d-812d-421b72f854de&DocuEnvelope=AB52A90E-BDC7-4F59-BFBD-90E32E984EA7&send=1", url)
    end

    should "be able to get a correction view url" do
      stub_request(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/views/correct.json")
        .to_return(:body => {
          "url" => "http://localhost/someurl"
        }.to_json)
      url = @envelope.correct_url({
        :returnUrl => "http://www.docusign.com",
      })
      assert_requested(:post, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/views/correct.json")
      assert_equal("http://localhost/someurl", url)
    end

    should "be able to get the combined pdf" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/documents/combined.json")
        .to_return(:body => "pdf goes here")
      assert_equal("pdf goes here", @envelope.documents_combined)
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/documents/combined.json")
    end

    should "be able to get the combined pdf using class method" do
      stub_request(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/documents/combined.json")
        .to_return(:body => "pdf goes here")
      assert_equal("pdf goes here", Docusigner::Envelope.documents_combined(@envelope.id, @envelope.prefix_options))
      assert_requested(:get, "https://demo.docusign.net/restapi/v2/accounts/1234-asdf/envelopes/qwer-7890/documents/combined.json")
    end
  end

end
