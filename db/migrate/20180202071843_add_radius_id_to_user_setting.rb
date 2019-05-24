class AddRadiusIdToUserSetting < ActiveRecord::Migration
  def change
    add_column :user_settings, :radius_id, :string, default: '0'
  end
end
