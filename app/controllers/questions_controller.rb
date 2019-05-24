class QuestionsController < ApplicationController
  load_and_authorize_resource

  # GET /questions.json
  def index
    @questions = Question.where(deactivate: false).where.not(user_id: current_user.id)

    if params[:radius]
      if params[:radius] == '0'
        @questions = @questions
      end

      if params[:radius] == 'all'
        @questions = @questions
      end

      if params[:radius] == '1'
        @questions = @questions.near(user_cordinates.values, 10)
      end

      if params[:radius] == '2'
        @questions = @questions.near(user_cordinates.values, 50)
      end

      if params[:radius] == '3'
        @questions = @questions.near(user_cordinates.values, 250)
      end

      if params[:radius] == '4'
        @questions = @questions.near(user_cordinates.values, 1000)
      end

      if params[:radius] == '5'
        @questions = @questions
      end
    end
    if params[:random]
      @questions = @questions.order('RANDOM()')
      current_user.update_attribute(:questions_last_checked_at, Time.now)
    else
      @questions = current_user.questions.where(deactivate: false).order('id desc')
    end
  end

  # POST /questions.json
  def create
    if user_cordinates
      @question = current_user.questions.new(question_params.merge(user_cordinates))
    else
      @question = current_user.questions.new(question_params)
    end
    respond_to do |format|
      if @question.save
        format.json { render :show, status: :created, location: @question }
      else
        format.json do
          render json: @question.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def question_params
    params.require(:question).permit(:text)
  end

  def ransack_params
    params.select { |key| ['id_not_in', 'user_id_not_eq'].include?(key) }
  end
end
