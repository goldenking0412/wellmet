class User < ActiveRecord::Base
  ONLINE_TIMEOUT = 5.minutes
  UNDERAGE_THRESHOLD = 19
  AGE_RANSACKS = {
    '19u' => [['>=', 19]],
    '20s' => [['<=', 20], ['>', 30]],
    '30s' => [['<=', 30], ['>', 40]],
    '40s' => [['<=', 40], ['>', 50]],
    '50s' => [['<=', 50], ['>', 60]],
    '60a' => [['<=', 60]],
    '19a' => [['<=', 19]]
  }.freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  has_many :questions, dependent: :delete_all
  has_many :answers, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests
  has_many :categories, through: :interests
  has_many :hails
  has_many :user_blocks
  has_many :blocked_users, through: :user_blocks
  has_one :user_setting, dependent: :destroy
  has_many :user_interest_shares

  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            format: {
              with: /\A[a-z0-9_]{3,10}\z/,
              message: 'is invalid. Must be longer than 3 characters and max 10 characters. Dashes, Underscore, Numbers, Capital letters allowed but spaces are not allowed'
            }

  validates :bio, length: { maximum: 170 }
  validates :date_of_birth, presence: true
  validates :gender, inclusion: %w(male female)
  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A^[a-z]+[a-z0-9._]+@[a-z]+\.[a-z.]{3,5}$\z/,
              message: 'is invalid.'
            }
  validates :location,
            presence: true,
            format: {
              with: /[A-Za-z0-9'\.\-\s\,\:]/,
              message: "allows letters, numbers, spaces and {:.,-}"
            }


  after_create :create_user_setting

  scope :query_by_age_keys, -> (age_keys) {
    query = age_keys.map do |age_key|
      anded = AGE_RANSACKS[age_key].map do |age_ransack|
        year = Time.zone.now - age_ransack[1].years
        "date_of_birth #{age_ransack[0]} '#{year}'"
      end.join(' AND ')
      "(#{anded})"
    end.join(' OR ')

    where(query)
  }

  geocoded_by :address

  def active_for_authentication?
    super and self.deactivate == false
  end

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid.to_s).first
    unless user
      user = User.new(
        email: auth.info.email,
        gender: auth.extra.raw_info.gender,
        password: Devise.friendly_token[0,20]
      )
      user.provider = auth.provider
      user.uid = auth.uid
      if ["facebook"].include?(auth.provider)
        user.save(:validate => false)
      elsif ["google"].include?(auth.provider)
        user.save(:validate => false)
      end
      user.save(:validate => false)
    end
    user
  end

  def create_user_setting
    return if user_setting

    UserSetting.create!(
      ages: { '19u' => age < 19,  '19a' => age >= 19 },
      common_interests_count: 1,
      radius: 1000,
      user_id: id,
      radius_id: "0"
    )
  end

  def username=(value)
    write_attribute(:username, value.downcase) if value
  end

  def top_category_id
    interests.select('count(category_id) as count, category_id')
      .where('user_interests.like = true')
      .group(:category_id)
      .order('count desc')
      .first
      .try(:category_id)
  end

  def points
    answers.appreciated.count
  end

  def email_required?
    false
  end

  def update_geolocation(geolocation)
    User.where(id: id).update_all geolocation.merge(geolocation_updated_at: Time.now) if !geolocation.nil?
  end

  def age
    now = Time.now.utc.to_date
    now.year - date_of_birth.year - (date_of_birth.to_date.change(year: now.year) > now ? 1 : 0)
  end

  def hail?(user)
    underage? == user.underage?
  end

  def underage?
    age <= UNDERAGE_THRESHOLD
  end

  def self.find_for_authentication(conditions)
    conditions[:username].to_s.downcase!
    super(conditions)
  end

  def distance_from_coordinates(coordinates)
    distance_to(coordinates)
  end
end
