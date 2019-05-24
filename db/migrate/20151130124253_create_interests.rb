class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :category_id, null: false
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :interests, :category_id
  end
end
