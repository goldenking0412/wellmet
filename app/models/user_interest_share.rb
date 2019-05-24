class UserInterestShare < ActiveRecord::Base
  belongs_to :user
  belongs_to :interest

  validates :user_id,
            presence: true,
            uniqueness: { scope: [:to_user_id, :interest_id] }
  validates :interest,
            presence: true

  scope :between_users, -> (user_id, to_user_id){
    where(
      %{
        (user_id = :user_id AND to_user_id = :to_user_id) OR
        (user_id = :to_user_id AND to_user_id = :user_id)
      },
      user_id: user_id,
      to_user_id: to_user_id
    )
  }
end
