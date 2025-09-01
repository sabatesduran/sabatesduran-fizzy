class PushNotificationJob < ApplicationJob
  def perform(notification)
    NotificationPusher.new(notification).push
  end
end
