module Docusigner
  class UserSettings < Docusigner::Base
    belongs_to :user
    singleton

    self.collection_name = "settings"
    self.element_name = "settings"

    # the create endpoint requires attributes to be nested under newUsers
    def as_json
      { "userSettings" => user_settings.map(&:as_json) }
    end

    def load(*attrs)
      attrs[0] = {:user_settings => attrs[0]}
      super(*attrs)
    end

    def set(key, value)
      user_settings.detect{|us| key == us.name}.value = value
    end

  end
end
