# Docusigner

This gem is meant to be a simple ActiveResource based interface to DocuSign's REST api.  Where applicable, objects know about their association relationships.

You can read more about DocuSign's REST API:

* [Developer Center](http://www.docusign.com/developers-center)
* [API Documentation (PDF)](http://www.docusign.com/sites/default/files/REST_API_Guide_v2.pdf)

*SPECIAL NOTE*: I do not yet have access to the production server, so please consider this a beta.  It has only been tested against the demo server and against the expected responses provided by the above API guide.


## Requirements

* `reactive_resource`
* `multipart_post`

This library will handle multipart post requests to DocuSign and provide the correct headers for the individual posts.  The `multipart_post` gem is required for its internals, but not used as it did not allow the headers DocuSign expects. 

## Setup

You can use either the X-DocuSign-Authentication header or an OAuth2 bearer token to access the API.  Configuration for your app is simple.

### X-DocuSign-Authentication

    Docusigner::Base.authentication = {
    	:username => "your_username_here",
    	:password => "your_password_here",
    	:integrator_key => "your_integrator_key_here"
    }
    
### OAuth2

    Docusigner::Base.token = "your_api_token"
    
Additionally, you can easily request (or revoke) a token through the API.

	# request an OAuth2 token
	token = Docusigner::Oauth2.token("username", "password", "integrator_key")
	
	# revoke an OAuth2 token
	Docusigner::Oauth2.revoke("token")
	
### Domain

By default, the API points to the development platform at https://demo.docusign.net.  Changing to the live site is simple:

	Docusigner::Base.site = "https://www.docusign.net/restapi/v2"
	
## Usage

Once you've configured the client, accessing resources is easy.  This client is based off of [reactive_resource](http://github.com/justinweiss/reactive_resource) which is built off of [active_resource](http://api.rubyonrails.org/classes/ActiveResource/Base.html).  Code should look similar to using ActiveRecord objects.

### Examples:

#### Fetch basic account information

	# find the account
	account = Docusigner::Account.find(1234)
	
	# access basic attributes
	account.id
	=> 1234
	account.name
	=> "My account name" 

	# list templates
	account.templates
	=> [#<Docusigner::Template>, #<Docusigner::Template>]

#### Create an envelope

	envelope = Docusigner::Envelope.new({
	  :account_id => 1234,
	  :emailSubject => "Fee Agreement",
      :emailBlurb => "Please sign the attached document"
      :recipients => {
        :signers => [
          {
            :email => "signer@gmail.com",
            :name => "Bob Smith",
            :recipientId => 1,
            :clientUserId => 123, # if you want to do 
            :tabs => {
            	# can add tabs here
            },
		  }
        ]
      },
      :documents => [
        {
          :name => "Fee Agreement",
          :documentId => 333,
        }
      ],
      :status => Docusigner::Envelope::Status::SENT
	})
	envelope.add_document(File.open("/path/to/document.pdf"), 333)
	envelope.save
	
For the most part, the complex data structures expected as parameters can be expressed with nested hashes when creating elements.

## Contributing

If you would like to contribute, please fork my [repository](http://github.com/chingor13/docusigner) and send me a pull request.  Please include tests.

I have not implemented every API endpoint, as I do not have enough time right now.