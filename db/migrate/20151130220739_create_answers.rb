class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_id, null: false
      t.integer :question_id, null: false
      t.text :text, null: false
      t.boolean :appreciated, default: false
      t.timestamps null: false
    end

    add_index :answers, :user_id
    add_index :answers, :question_id
  end
end
