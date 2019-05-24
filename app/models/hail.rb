class Hail < ActiveRecord::Base
  belongs_to :user
  belongs_to :to_user, class_name: 'User'

  scope :accepted, ->() { where(accepted: true) }

  validates :user, presence: true
  validates :to_user,
            presence: true,
            uniqueness: { scope: :user }
  validates :message, presence: true

  scope :between_users, ->(user_id, to_user_id){
    where(
      %{
        (user_id = :user_id AND to_user_id = :to_user_id) OR
        (user_id = :to_user_id AND to_user_id = :user_id)
      },
      user_id: user_id,
      to_user_id: to_user_id
    )
  }

  scope :unread, -> { where(read: false) }
end
