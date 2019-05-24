class UserSettingsChatNotificationsDefaultTrue < ActiveRecord::Migration
  def change
    change_column :user_settings, :chat_notification, :boolean, default: true
  end
end
