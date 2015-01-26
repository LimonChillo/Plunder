class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @conversations = Conversation.all
    respond_with(@conversations)
  end

  def show
    @messages = Message.of_conversation(params[:id])
  end

  def new
    @conversation = Conversation.new
    respond_with(@conversation)
  end

  def edit
  end

  def create
    requested_conversation = Conversation.by_partners(params[:id1], params[:id2]).first
    if requested_conversation.nil?
      requested_conversation = Conversation.create(user_1_id: params[:id1], user_2_id: params[:id2])
    end
    redirect_to conversation_path requested_conversation.id
  end

  def update
    @conversation.update(conversation_params)
    respond_with(@conversation)
  end

  def destroy
    @conversation.destroy
    respond_with(@conversation)
  end

  def new_message
    Message.create(text: params[:text], sender: current_user.id, conversation_id: params[:conversation_id])

    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end

  private
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    def conversation_params
      params.require(:conversation).permit(:user_1_id, :user_2_id)
    end
end