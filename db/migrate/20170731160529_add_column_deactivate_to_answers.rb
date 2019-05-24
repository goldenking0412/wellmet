class AddColumnDeactivateToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :deactivate, :boolean, default: false, null: false
  end
end
