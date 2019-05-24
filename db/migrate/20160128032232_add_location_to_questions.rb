class AddLocationToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :latitude, :float
    add_column :questions, :longitude, :float
    add_index :questions, :latitude
    add_index :questions, :longitude
  end
end
