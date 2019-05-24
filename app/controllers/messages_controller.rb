class MessagesController < ApplicationController
  load_and_authorize_resource

  UserBlocked = Class.new(StandardError)
  NoHails = Class.new(StandardError)

  # GET /messages
  # GET /messages.json
  def index
    raise UserBlocked if UserBlock.between_users(current_user.id, params[:to_user_id_eq]).any?
    raise NoHails if Hail.between_users(current_user.id, params[:to_user_id_eq]).empty?
    @messages = Message.between_users(current_user.id, params[:to_user_id_eq]).order('created_at ASC')
    current_user.update_attribute(:last_chatted_user_id, params[:to_user_id_eq]) if params[:to_user_id_eq] && params[:poll]
    Message.where(user_id: params[:to_user_id_eq], to_user_id: current_user.id).update_all(read: true)
  rescue UserBlocked
    current_user.update_attribute(:last_chatted_user_id, nil) if current_user.last_chatted_user_id == params[:to_user_id_eq]
    render json: { error: 'blocked' }, status: :unprocessable_entity
  rescue NoHails
    current_user.update_attribute(:last_chatted_user_id, nil) if current_user.last_chatted_user_id == params[:to_user_id_eq]
    render json: { error: 'no_hails' }, status: :unprocessable_entity
  end

  # POST /messages
  # POST /messages.json
  def create
    raise UserBlocked if UserBlock.between_users(current_user.id, message_params[:to_user_id]).any?
    raise NoHails if Hail.accepted.between_users(current_user.id, message_params[:to_user_id]).empty?

    @message = current_user.messages.new(message_params)

    respond_to do |format|
      if @message.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @message.errors.full_messages, status: :unprocessable_entity }
      end
    end
  rescue UserBlocked
    current_user.update_attribute(:last_chatted_user_id, nil) if current_user.last_chatted_user_id == message_params[:to_user_id]
    render json: { error: 'blocked' }, status: :unprocessable_entity
  rescue NoHails
    render json: { error: 'no_hails' }, status: :unprocessable_entity
  end

  def destroy_all
    ActiveRecord::Base.transaction do
      to_user = User.find(params[:to_user_id_eq])

      Message.between_users(current_user.id, to_user.id).destroy_all
      Hail.between_users(current_user.id, to_user.id).destroy_all
      UserInterestShare.between_users(current_user.id, to_user.id).destroy_all

      current_user.update_attribute(:last_chatted_user_id, nil) if current_user.last_chatted_user_id == to_user.id
      to_user.update_attribute(:last_chatted_user_id, nil) if to_user.last_chatted_user_id == current_user.id

      render json: {}, status: :ok
    end
  end

  private

  def message_params
    params.require(:message).permit(:to_user_id, :text)
  end

  def ransack_prams
    params.select { |key| ['to_user_id_eq'].include? key }
  end
end
