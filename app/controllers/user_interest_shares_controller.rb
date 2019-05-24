class UserInterestSharesController < ApplicationController
  # GET /user_interest_shares.json
  def index
    @user_interest_shares = UserInterestShare.where('user_id = :user_id OR to_user_id = :to_user_id', user_id: params[:user_id], to_user_id: params[:to_user_id])
  end

  # POST /user_interest_shares.json
  def create
    @user_interest_share = current_user.user_interest_shares.new(user_interest_share_params)

    respond_to do |format|
      if @user_interest_share.save
        format.json { render :show, status: :created, location: @user_interest_share }
      else
        format.json { render json: @user_interest_share.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_user.user_interest_shares.find(params[:id]).destroy
    render json: {}
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_interest_share_params
      params.require(:user_interest_share).permit(:user_id, :to_user_id, :interest_id)
    end
end
