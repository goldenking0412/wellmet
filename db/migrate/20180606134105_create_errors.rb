class CreateErrors < ActiveRecord::Migration
  def change
    create_table :errors do |t|
      t.string :not_found
      t.string :internal_server_error

      t.timestamps null: false
    end
  end
end
