class CreateInterestPreferences < ActiveRecord::Migration
  def change
    create_table :interest_preferences do |t|
      t.boolean :like, null: false
      t.integer :interest_id, null: false
      t.integer :user_id, null: false
      t.timestamps null: false
    end
    add_index :interest_preferences, :user_id
    add_index :interest_preferences, [:user_id, :interest_id], unique: true
  end
end
