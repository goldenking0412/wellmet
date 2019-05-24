class UserInterestsController < ApplicationController
  load_and_authorize_resource

  def index
    @interest = Interest.where(deactivate: true).each{ |interest| interest.user_interests.each{ |user_interest| user_interest.update(deactivate: true) } }
    @user_interests = UserInterest.includes(:user)
                                  .where(deactivate: false)
                                  .limit(params[:limit] || 500)
                                  .order('created_at desc')
                                  .ransack(ransack_params)
                                  .result
  end

  # POST /user_interests.json
  def create
    @user_interest = current_user.user_interests.new(user_interest_params)

    respond_to do |format|
      if @user_interest.save
        format.json { render :show, status: :created, location: @user_interest }
      else
        format.json do
          render json: @user_interest.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /user_interests/1.json
  def destroy
    @user_interest.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_interest_params
      params.require(:user_interest).permit(:interest_id, :comment, :like)
    end

    def ransack_params
      params.select { |key| ['interest_id_eq', 'user_id_eq'].include?(key) }
    end
end
