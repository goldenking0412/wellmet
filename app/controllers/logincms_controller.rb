class LogincmsController < ApplicationController
  before_action :set_logincm, only: [:show, :edit, :update, :destroy]

  # GET /logincms
  # GET /logincms.json
  def index
    @logincms = Logincm.all
  end

  # GET /logincms/1
  # GET /logincms/1.json
  def show
  end

  # GET /logincms/new
  def new
    @logincm = Logincm.new
  end

  # GET /logincms/1/edit
  def edit
  end

  # POST /logincms
  # POST /logincms.json
  def create
    @logincm = Logincm.new(logincm_params)

    respond_to do |format|
      if @logincm.save
        format.html { redirect_to @logincm, notice: 'Logincm was successfully created.' }
        format.json { render :show, status: :created, location: @logincm }
      else
        format.html { render :new }
        format.json { render json: @logincm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logincms/1
  # PATCH/PUT /logincms/1.json
  def update
    respond_to do |format|
      if @logincm.update(logincm_params)
        format.html { redirect_to @logincm, notice: 'Logincm was successfully updated.' }
        format.json { render :show, status: :ok, location: @logincm }
      else
        format.html { render :edit }
        format.json { render json: @logincm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logincms/1
  # DELETE /logincms/1.json
  def destroy
    @logincm.destroy
    respond_to do |format|
      format.html { redirect_to logincms_url, notice: 'Logincm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_logincm
      @logincm = Logincm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def logincm_params
      params.require(:logincm).permit(:content)
    end
end
