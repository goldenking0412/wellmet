class CreateHails < ActiveRecord::Migration
  def change
    create_table :hails do |t|
      t.integer :user_id
      t.integer :to_user_id
      t.string :message
      t.boolean :accepted

      t.timestamps null: false
    end
  end
end
