class InterestsController < ApplicationController
  load_and_authorize_resource

  # GET /interests.json
  def index
    @categories = Category.where(deactivate: true).each{ |category| category.interests.each{ |interest| interest.update(deactivate: true) } }
    @interests = Interest
                  .includes(:category)
                  .where(deactivate: false)
                  .limit(params[:limit] || 500)
                  .ransack(ransack_params)
                  .result

    if params[:unlocked_to_user_id]
      common_interest_ids = current_user.user_interests.map do |user_interest|
        User.find(params[:unlocked_to_user_id]).user_interests.find_by(interest_id: user_interest.interest_id, like: user_interest.like).try(:interest_id)
      end.compact

      shared_interest_ids =
        UserInterestShare.where('user_id = :user_id OR to_user_id = :user_id OR user_id = :to_user_id OR to_user_id = :to_user_id',
                                user_id: current_user.id,
                                to_user_id: params[:unlocked_to_user_id]).pluck(:interest_id)
      ap shared_interest_ids

      @interests = @interests.where(id: current_user.user_interests.pluck(:interest_id) - common_interest_ids - shared_interest_ids)
      return
    end

    if params[:common_to_user_id]
      common_interest_ids = current_user.user_interests.map do |user_interest|
        User.find(params[:common_to_user_id]).user_interests.find_by(interest_id: user_interest.interest_id, like: user_interest.like).try(:interest_id)
      end.compact

      shared_interest_ids =
        UserInterestShare.where('(user_id = :user_id AND to_user_id = :to_user_id) OR (user_id = :to_user_id And to_user_id = :user_id)',
                                user_id: current_user.id,
                                to_user_id: params[:common_to_user_id]).pluck(:interest_id)

      @interests = @interests.where(id: common_interest_ids + shared_interest_ids)
      return
    end

    if added_date
      @interests = @interests
                    .added_since(added_date)
                    .with_users_count
                    .order('users_count desc')
    end

    if params[:not_added]
      @interests = @interests.where.not(id: current_user.user_interests.select(:interest_id))
    end

    if params[:user_id]
      @interests = @interests.joins(:user_interests).merge(UserInterest.where(user_id: params[:user_id]))
    end

    @interests = @interests.sort_by(&:all_time_users_count).reverse
  end

  def show
    @interest = Interest.includes(:category)
                        .find(params[:id])
  end

  def create
    @interest = Interest.new(interest_params)
    respond_to do |format|
      if @interest.save
        format.json do
          render :show, status: :created
        end
      else
        format.json do
          render json: @interest.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def interest_params
    params.require(:interest).permit(:name, :category_id)
  end


  def ransack_params
    params.select { |key| ['name_cont', 'category_id_eq', 'id_in', 'users_id_eq'].include?(key) }
  end

  def added_date
    @added_date ||= if params[:added_date_range] == 'today'
      Time.now.beginning_of_day
    elsif params[:added_date_range] == 'this_month'
      Time.now.beginning_of_month
    elsif params[:added_date_range] == 'this_week'
      Time.now.beginning_of_week
    elsif params[:added_date_range] == 'lifetime'
      '1970-01-01'
    end
  end
end
