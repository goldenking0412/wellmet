class UserBlock < ActiveRecord::Base
  belongs_to :user
  belongs_to :blocked_user, foreign_key: :blocked_user_id, class_name: 'User'
  validates :user_id, presence: true
  validates :blocked_user_id,
            presence: true,
            uniqueness: { scope: :user_id, message: 'already blocked' }

  after_create :remove_last_chatted_user

  scope :between_users, -> (user_id, blocked_user_id){
    where(
      %{
        (user_id = :user_id AND blocked_user_id = :blocked_user_id) OR
        (user_id = :blocked_user_id AND blocked_user_id = :user_id)
      },
      user_id: user_id,
      blocked_user_id: blocked_user_id
    )
  }

  private

  def remove_last_chatted_user
    user.update_attribute(:last_chatted_user_id, nil) if user.last_chatted_user_id == blocked_user.id
    blocked_user.update_attribute(:last_chatted_user_id, nil) if blocked_user.last_chatted_user_id == user.id

    Hail.between_users(user.id, blocked_user.id).destroy_all

    Message.between_users(user.id, blocked_user.id).destroy_all
  end
end
