class UserSettingsController < ApplicationController
  load_and_authorize_resource

  # GET /user_settings
  # GET /user_settings.json
  def index
    @user_setting = current_user.user_setting
  end

  # POST /user_settings
  # POST /user_settings.json
  def create
    @user_setting = current_user.user_setting || current_user.build_user_setting

    @user_setting.assign_attributes user_setting_params
    respond_to do |format|
      if @user_setting.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @user_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_setting_params
      params.require(:user_setting).permit(
        :user_id,
        :radius,
        :common_interests_count,
        :gender,
        :radius_id,
        { ages: [User::AGE_RANSACKS.keys] },
        :sound_notification,
        :question_notification,
        :hail_notification,
        :chat_notification,
        :allow_to_locate_me,
        :city_visibility
      )
    end
end
