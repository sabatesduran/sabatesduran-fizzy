module User::Configurable
  extend ActiveSupport::Concern

  included do
    has_one :settings, class_name: "User::Settings", dependent: :destroy
    has_many :push_subscriptions, class_name: "Push::Subscription", dependent: :delete_all

    after_create :create_settings, unless: :system?
  end
end
