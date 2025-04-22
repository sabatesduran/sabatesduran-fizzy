class Mention < ApplicationRecord
  include Notifiable

  belongs_to :container, polymorphic: true
  belongs_to :mentioner, class_name: "User"
  belongs_to :mentionee, class_name: "User", inverse_of: :mentions
end
