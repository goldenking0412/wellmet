class NotificationsController < ApplicationController
  def index
    if(current_user)
      user_setting = current_user.user_setting || UserSetting.new
      notifications = {}
      notifications[:unread_messages] = user_setting.chat_notification ? Message.where(to_user_id: current_user.id).unread.count : 0
      notifications[:unread_hails] = user_setting.hail_notification ? Hail.where(to_user: current_user.id).unread.count : 0

      if(user_setting.question_notification)
        nearby_questions = Question.near(user_cordinates.try(:values), current_user.user_setting.try(:radius) || 1000, units: :km)
          .where.not(user_id: current_user.id)

        nearby_questions = nearby_questions.where('created_at > ?', current_user.questions_last_checked_at) if current_user.questions_last_checked_at

        not_answered_by_current_user = nearby_questions.select do |q|
          q.answers.where(user_id: current_user.id).count == 0
        end

        notifications[:new_questions] = not_answered_by_current_user.size
      end
    end

    render json: notifications
  end
end
