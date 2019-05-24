class CreateUserInterestShares < ActiveRecord::Migration
  def change
    create_table :user_interest_shares do |t|
      t.integer :user_id, null: false
      t.integer :user_interest_id, null: false
      t.timestamps null: false
    end
    add_index :user_interest_shares, [:user_id, :user_interest_id], unique: true
  end
end
