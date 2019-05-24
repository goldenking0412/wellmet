class UserBlocksController < ApplicationController
  authorize_resource

  # GET /user_blocks
  # GET /user_blocks.json
  def index
    @user_blocks = current_user.user_blocks
  end

  # POST /user_blocks
  # POST /user_blocks.json
  def create
    if user_block_params[:username]
      @user_block = UserBlock.new(user_id: current_user.id, blocked_user_id: User.find_by!(username: user_block_params[:username].downcase).id)
    else
      @user_block = UserBlock.new(user_block_params.merge(user_id: current_user.id))
    end

    ActiveRecord::Base.transaction do
      respond_to do |format|
        if @user_block.save
          Message.between_users(current_user.id, @user_block.blocked_user_id).destroy_all
          format.json { render :show, status: :created, location: @user_block }
        else
          format.json { render json: @user_block.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /user_blocks/1
  # DELETE /user_blocks/1.json
  def destroy
    @user_block = UserBlock.find(params[:id])
    @user_block.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_block_params
      params.require(:user_block).permit(:blocked_user_id, :username)
    end
end
