class AddNotificagionSettingsForUsers < ActiveRecord::Migration
  def change
    add_column :user_settings, :sound_notification, :boolean, default: true
    add_column :user_settings, :question_notification, :boolean, default: true
    add_column :user_settings, :hail_notification, :boolean, default: true
    add_column :user_settings, :chat_notification, :boolean, defaut: true
  end
end
