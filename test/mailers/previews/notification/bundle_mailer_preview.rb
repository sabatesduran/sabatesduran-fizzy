class Notification::BundleMailerPreview < ActionMailer::Preview
  def notification
    ApplicationRecord.current_tenant = "1065895976"
    Notification::BundleMailer.notification Notification::Bundle.take!
  end
end
