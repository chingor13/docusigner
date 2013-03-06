module Docusigner
  class LoginInformation < Docusigner::Base
    singleton

    class << self
      def change_password(email, current_password, new_password, options = {})
        body = {
          "currentPassword" => current_password,
          "email" => email,
          "newPassword" => new_password
        }.merge(options).to_json
        resp = put(:password, {}, body)
      end
    end
  end
end
