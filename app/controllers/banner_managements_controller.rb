class BannerManagementsController < ApplicationController
  before_action :set_banner_management, only: [:show, :edit, :update, :destroy]

  # GET /banner_managements
  # GET /banner_managements.json
  def index
    @banner_managements = BannerManagement.all
  end

  # GET /banner_managements/1
  # GET /banner_managements/1.json
  def show
  end

  # GET /banner_managements/new
  def new
    @banner_management = BannerManagement.new
  end

  # GET /banner_managements/1/edit
  def edit
  end

  # POST /banner_managements
  # POST /banner_managements.json
  def create
    @banner_management = BannerManagement.new(banner_management_params)

    respond_to do |format|
      if @banner_management.save
        format.html { redirect_to @banner_management, notice: 'Banner management was successfully created.' }
        format.json { render :show, status: :created, location: @banner_management }
      else
        format.html { render :new }
        format.json { render json: @banner_management.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banner_managements/1
  # PATCH/PUT /banner_managements/1.json
  def update
    respond_to do |format|
      if @banner_management.update(banner_management_params)
        format.html { redirect_to @banner_management, notice: 'Banner management was successfully updated.' }
        format.json { render :show, status: :ok, location: @banner_management }
      else
        format.html { render :edit }
        format.json { render json: @banner_management.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banner_managements/1
  # DELETE /banner_managements/1.json
  def destroy
    @banner_management.destroy
    respond_to do |format|
      format.html { redirect_to banner_managements_url, notice: 'Banner management was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner_management
      @banner_management = BannerManagement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def banner_management_params
      params.require(:banner_management).permit(:name, :title, :position, :heading, :subtitle1, :subtitle2,:image, :heading_position)
    end
end
