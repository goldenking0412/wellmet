class AddQuestionsLastCheckedAtForUsers < ActiveRecord::Migration
  def change
    add_column :users, :questions_last_checked_at, :datetime
  end
end
