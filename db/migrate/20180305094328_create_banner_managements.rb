class CreateBannerManagements < ActiveRecord::Migration
  def change
    create_table :banner_managements do |t|
      t.string :name
      t.string :title
      t.integer :position
      t.string :heading
      t.string :subtitle1
      t.string :subtitle2

      t.timestamps null: false
    end
  end
end
