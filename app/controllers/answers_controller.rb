class AnswersController < ApplicationController
  load_and_authorize_resource

  # GET /answers.json
  def index
    @answers = Answer.search(ransack_params).result
    @answers = @answers.limit(params[:limit]) if params[:limit]
  end

  # GET /answers/1.json
  def show
  end

  # POST /answers.json
  def create
    @answer = current_user.answers.new(answer_params)

    respond_to do |format|
      if @answer.save
        format.json { render :show, status: :created, location: @answer }
      else
        format.json do
          render json: @answer.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PUT /answers.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.json { render :show, location: @answer }
      else
        format.json do
          render json: @answer.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white
  # list through.
  def answer_params
    allowed_params = [:question_id, :text]
    if @answer && @answer.persisted? && current_user.id == @answer.question.user_id
      allowed_params << :appreciated
    end
    params.require(:answer).permit(*allowed_params)
  end

  def ransack_params
    params.select { |key| ['id_eq', 'question_id_in', 'question_id_eq', 'user_id_eq'].include?(key) }
  end
end
