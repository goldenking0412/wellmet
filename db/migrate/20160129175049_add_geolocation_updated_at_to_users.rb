class AddGeolocationUpdatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :geolocation_updated_at, :datetime
    add_index :users, :geolocation_updated_at
  end
end
