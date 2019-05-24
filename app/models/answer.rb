class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :user, presence: true
  validates :question, presence: true
  validates :text, presence: true

  scope :appreciated, ->() {
    where(appreciated: true)
  }
  scope :unread, -> { where(read: false) }
end
