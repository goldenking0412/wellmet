class DropInterestPreferences < ActiveRecord::Migration
  def up
    drop_table :interest_preferences
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
