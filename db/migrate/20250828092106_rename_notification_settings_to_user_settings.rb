class RenameNotificationSettingsToUserSettings < ActiveRecord::Migration[8.1]
  def change
    rename_table :notification_settings, :user_settings
  end
end
