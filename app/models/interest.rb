class Interest < ActiveRecord::Base
  belongs_to :category
  has_many :user_interests
  has_many :users, through: :user_interests

  validates :category,
            presence: true
  validates :name,
            presence: true,
            uniqueness: {scope: :category}

  scope :with_users_count, lambda {
    joins(:user_interests)
      .select('interests.*, count(user_interests.id) as users_count').group(:id)
  }

  scope :added_since, lambda {|added_date|
    joins(:user_interests)
      .where('user_interests.created_at > ?', added_date)
  }

  scope :not_added_by_user, lambda {|user|
    includes(:user_interests).where(user_interests: { id: nil, user_id: user.id })
  }

  def all_time_users_count
    @all_time_users_count ||= users.count
  end

  def like_count
    @like_count ||= user_interests.where(like: true).count
  end

  def dislike_count
    @dislike_count ||= user_interests.where(like: false).count
  end

  def comments_count
    @comments_count ||= user_interests.where.not(comment: nil).count
  end
end
