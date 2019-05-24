class AddProfilephotoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profilephoto, :string
  end
end
