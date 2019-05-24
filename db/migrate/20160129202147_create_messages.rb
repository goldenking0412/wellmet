class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :to_user_id
      t.string :text

      t.timestamps null: false
    end

    add_index :messages, :user_id
    add_index :messages, :to_user_id
  end
end
