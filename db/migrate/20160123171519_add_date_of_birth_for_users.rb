class AddDateOfBirthForUsers < ActiveRecord::Migration
  def change
    add_column :users, :date_of_birth, :datetime, null: false, default: '2020-01-01'
  end
end
