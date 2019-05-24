class HailsController < ApplicationController
  load_and_authorize_resource

  # GET /hails
  # GET /hails.json
  def index
    @hails = Hail.where(to_user_id: current_user.id)
      .search(ransack_params)
      .result
    @hails.update_all(read: true)
  end

  # POST /hails
  # POST /hails.json
  def create
    @hail = current_user.hails.new(hail_params)

    respond_to do |format|
      if @hail.save
        format.json { render :show, status: :created, location: @hail }
      else
        format.json { render json: @hail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hails/1
  # PATCH/PUT /hails/1.json
  def update
    respond_to do |format|
      if @hail.update(hail_params)
        format.json { render :show, status: :ok, location: @hail }
      else
        format.json { render json: @hail.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    hail = Hail.find_by!(id: params[:id], to_user_id: current_user.id)
    hail.destroy

    current_user.update_attribute(:last_chatted_user_id, nil) if current_user.last_chatted_user_id == hail.user_id

    render json: {}
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def hail_params
    params.require(:hail).permit(:user_id, :to_user_id, :message, :accepted)
  end

  def ransack_params
    params.select { |k| ['user_id_eq'].include? k }
  end
end
