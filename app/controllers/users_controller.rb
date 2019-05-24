class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :set_user, only: [:update, :show]
  before_action :authenticate_user!, except: [:index]

  def index
    @users = User.ransack(ransack_params)
                 .result
    # valid_user_ids = UserSetting.where(allow_to_locate_me: true).select(:user_id)
    # @users = @users.where(id: valid_user_ids)
    if params[:for_locate] == true
      @users = @users.joins(:user_setting)
                     .merge(UserSetting.where(allow_to_locate_me: true))
      if current_user
        chatting_user_ids = Message.for_user(current_user.id).pluck(:user_id, :to_user_id).flatten.uniq
        @users = @users.where('users.id NOT IN (?)', chatting_user_ids) if chatting_user_ids.any?
      end

      @users = @users.query_by_age_keys(['19u']) if current_user && current_user.age < 19
      @users = @users.query_by_age_keys(['19a']) if current_user && current_user.age >= 19
    end

    if params[:radius_id]
      if params[:radius_id] == '0'
        @users = @users
      end

      if params[:radius_id] == '1'
        @users = @users.near(user_cordinates.values, 10)
      end

      if params[:radius_id] == '2'
        @users = @users.near(user_cordinates.values, 50)
      end

      if params[:radius_id] == '3'
        @users = @users.near(user_cordinates.values, 250)
      end

      if params[:radius_id] == '4'
        @users = @users.near(user_cordinates.values, 1000)
      end

      if params[:radius_id] == '5'
        @users = @users.near(user_cordinates.values, 9999999999)
      end
    end

    # if !params[:radius].blank? && user_cordinates
    #   @users = @users.near(user_cordinates.values, params[:radius].to_i)
    # end
    if params[:specific_interest_ids]
      users_ids_with_specific_interests =
        current_user.user_interests.where(interest_id: params[:specific_interest_ids]).map do |user_interest|
          UserInterest.where(interest_id: user_interest.interest_id, like: user_interest.like)
            .where.not(user_id: current_user.id)
            .pluck(:user_id)
        end.reduce(:&)
      @users = @users.where(id: users_ids_with_specific_interests)
    end

    if params[:limit] && !params[:category_id]
      @users = @users.limit(params[:limit])
    end

    if params[:ages]
      params[:ages].select! { |age, selected| selected == 'true' }
      @users = @users.query_by_age_keys(params[:ages].keys)
    end

    if params[:chattable] == 'true'
      hails = Hail.where(%{ user_id = :user_id OR to_user_id = :user_id }, user_id: current_user.id).accepted
      @users = @users.where(id: hails.select(:to_user_id).map(&:to_user_id) + hails.select(:user_id).map(&:user_id))
    end

    if params[:online] == 'true'
      @users = @users.where('geolocation_updated_at >= ?', Time.zone.now - User::ONLINE_TIMEOUT)
    elsif params[:online] == 'false'
      @users = @users.where('geolocation_updated_at < ?', Time.zone.now - User::ONLINE_TIMEOUT)
    end

    if params[:hailed] == 'true'
      hails = Hail.where(to_user_id: current_user.id)
        .where('accepted IS NULL')
      @users = @users.where(id: hails.select(:user_id))
    end

    @users = @users.where(gender: params[:gender]) if !params[:gender].blank?

    if current_user
      @commmon_user_interests_counts = {}
      current_user.user_interests.each do |user_interest|
        @users.each do |user|
          @commmon_user_interests_counts[user.id] ||= 0
          @commmon_user_interests_counts[user.id] += user.user_interests.where(interest_id: user_interest.interest_id, like: user_interest.like).count
        end
      end
    end

    if current_user && params[:common_interests_count]
      common_interests_user_ids = @commmon_user_interests_counts.select { |_, v| v == params[:common_interests_count].to_i }.keys
      @users = @users.where(id: common_interests_user_ids)
    end


    # if params[:sort] == 'radius_asc' && user_cordinates
    #   puts @users.sort {|a, b| a.distance_from_coordinates(user_cordinates.values)}
    #   @users = @users.sort { |a, b| a.distance_from_coordinates(user_cordinates.values) <=> b.distance_from_coordinates(user_cordinates.values)  }
    # elsif params[:sort] == 'common_interests_count_desc'
    #   @users = @users.sort { |a, b| @commmon_user_interests.find { |i| i.user_id == a.id }.try(:count) <=> @commmon_user_interests.find { |i| i.user_id == b.id }.try(:count) }
    # elsif params[:sort] == 'gender_asc' && user_cordinates
    #   @users = @users.sort { |a, b| a.gender <=> b.gender }
    # end

    if params[:category_id]
      users = []
      Interest.where(category_id: params[:category_id]).all.each do |interest|
        if User.where(id: interest.try(:users).select(:id)).present?
          users << User.where(id: interest.try(:users).select(:id)).first
        end
      end
      if users & @users
        @users = users & @users
      else
        @users = nil
      end
    end
  end

  def update
    if params[:user][:password] || params[:user][:current_password] || params[:user][:confirm_password]
      if @user.valid_password? params[:user][:current_password]
        if @user.update password: params[:user][:password], password_confirmation: params[:user][:password_confirmation]
          @user.reload
          sign_in :user, @user
          render json: {}, status: :ok
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: ['Invalid password'] }, status: :unprocessable_entity
      end
    else
      date_of_birth = Time.new(params[:user][:birth_year].to_i, params[:user][:birth_month].to_i) rescue nil

      permitted_params = user_params
      permitted_params.merge!(date_of_birth: date_of_birth) if date_of_birth

      if @user.update_without_password permitted_params
        render json: {}, status: :ok
      else
        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  end

  def show
  end

  def create
    date_of_birth = Time.new(params[:user][:birth_year], params[:user][:birth_month]) rescue nil
    @user = User.new(user_params.merge(date_of_birth: date_of_birth))
    if @user.save
      sign_in(:user, @user)
      render 'show', status: 201
    else
      warden.custom_failure!
      render json: { errors: @user.errors.full_messages },
             status: 422
    end
  end

  def destroy
    current_user.destroy
    Message.where('user_id = :user_id OR to_user_id = :user_id', user_id: current_user.id).destroy_all
    Question.where(user_id: current_user.id).destroy_all
    UserInterestShare.where('user_id = :user_id OR to_user_id = :user_id', user_id: current_user.id)
    UserBlock.where('user_id = :user_id OR to_user_id = :user_id', user_id: current_user.id)
    Hail.where('user_id = :user_id OR to_user_id = :user_id', user_id: current_user.id)

    User.where(last_chatted_user_id: current_user.id).update_all(last_chatted_user_id: nil)

    render json: {}
  end

  private

  def user_params
    params.require(:user)
          .permit(:username, :email, :password, :password_confirmation, :location, :latitude, :longitude, :bio, :gender, :policy, :date_of_birth, :profilephoto, :current_sign_in_at, :last_logged_out_at)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ransack_params
    params.select { |key| ['id_in', 'id_not_eq'].include?(key) }
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username
  end
end
