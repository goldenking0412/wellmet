class UserInterest < ActiveRecord::Base
  belongs_to :interest
  belongs_to :user

  validates :interest,
            presence: true,
            uniqueness: { scope: :user }
  validates :user,
            presence: true
  validates :like,
            inclusion: { in: [true, false] }
end
