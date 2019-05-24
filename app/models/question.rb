class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :user, presence: true
  validates :text, presence: true
  geocoded_by :address
end
