class AddLikeToUserInterests < ActiveRecord::Migration
  def change
    add_column :user_interests, :like, :boolean, null: false, default: true
  end
end
