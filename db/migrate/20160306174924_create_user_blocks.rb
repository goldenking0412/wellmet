class CreateUserBlocks < ActiveRecord::Migration
  def change
    create_table :user_blocks do |t|
      t.integer :user_id, null: false
      t.integer :blocked_user_id, null: false

      t.timestamps null: false
    end
    add_index :user_blocks, [:user_id, :blocked_user_id], unique: true
  end
end
