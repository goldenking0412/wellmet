class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :slug, null: false
      t.string :description
      t.boolean :deactivate, default: false, null: false

      t.timestamps null: false
    end
  end
end
