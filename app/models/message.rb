class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :to_user, class_name: 'User'

  validates :text, presence: true
  validates :user, presence: true
  validates :to_user, presence: true

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
  scope :for_user, -> (user_id) { where('user_id = :user_id OR to_user_id = :user_id', user_id: user_id) }

  scope :unread, -> { where(read: false) }
end
