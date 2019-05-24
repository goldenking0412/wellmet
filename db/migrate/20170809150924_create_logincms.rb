class CreateLogincms < ActiveRecord::Migration
  def change
    create_table :logincms do |t|
      t.text :content, null: false

      t.timestamps null: false
    end
  end
end
