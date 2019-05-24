class AddReadColumns < ActiveRecord::Migration
  def change
    add_column :messages, :read, :boolean, default: false, null: false
    add_column :hails, :read, :boolean, default: false, null: false
    add_column :answers, :read, :boolean, default: false, null: false
  end
end
