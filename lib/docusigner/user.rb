class Docusigner::User < Docusigner::Base
  belongs_to :account

  schema do
    string "activationAccessCode"
    string "email"                  # required
    string "enableConnectForUser"
    string "firstName"
    string "groupList"
    string "lastName"
    string "middleName"
    string "password"
    string "sendActivationOnInvalidLogin"
    string "suffixName"
    string "title"
    string "userName"               # required

    # complex elements
    # forgottenPasswordInfo
    # userSettings
  end
end
