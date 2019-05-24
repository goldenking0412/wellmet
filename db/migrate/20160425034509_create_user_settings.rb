class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.integer :user_id
      t.decimal :radius
      t.integer :common_interests_count
      t.string :gender
      t.text :ages

      t.timestamps null: false
    end
  end
end
