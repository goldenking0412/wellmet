class AddColumnDeactivateToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :deactivate, :boolean, default: false, null: false
  end
end
