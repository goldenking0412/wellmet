class AddAllowToLocateCityVisibilityToUserSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :allow_to_locate_me, :boolean, default: true
    add_column :user_settings, :city_visibility, :string, default: 'public'
  end
end
