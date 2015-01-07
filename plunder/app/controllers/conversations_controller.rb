class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @conversations = Conversation.all
    respond_with(@conversations)
    #@messages = Message.joins(:conversation).where(:conversation => {:user_id_1 => 1, :user_id_2 => 2})
    #@messages = Message.joins(:conversation).all
  end

  def show
    #respond_with(@conversation)
    #@messages = Message.joins(:conversation).where(:conversations => {:user_1_id => [params[:id1], params[:id2]], :user_2_id => [params[:id1], params[:id2]]})
    @messages = Message.where(:conversation_id => params[:id])
  end

  def new
    @conversation = Conversation.new
    respond_with(@conversation)
  end

  def edit
  end

  def create
    # @conversation = Conversation.new(conversation_params)
    # @conversation.save
    # respond_with(@conversation)
    if !Conversation.where(:user_1_id => [params[:id1], params[:id2]], :user_2_id => [params[:id1], params[:id2]]).exists?
      Conversation.create(:user_1_id => params[:id1], :user_2_id => params[:id2])
    end
    redirect_to conversations_path
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

    Message.create(:text => params[:text], :sender => current_user.id, :conversation_id => params[:conversation_id])

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
