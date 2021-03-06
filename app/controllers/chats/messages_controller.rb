class Chats::MessagesController < Chats::ApplicationController
  before_action :chat_has_session, only: [:index, :create, :set_state_read]

  def index
    change_state(chat.messages, :may_deliver?, :deliver!)
    render json: chat.messages.order(:id)
  end

  def create
    session_id = chat.sessions.find_by(token: session_token).id
    session = Session.find(session_id)
    message = session.messages.new(message: params[:message])

    message.accept! if message.save
  end

  def set_state_read
    change_state(chat.messages, :may_read?, :read!)
  end

  private

  def chat_has_session
    if chat.sessions.where(token: session_token).empty?
      render body: nil, status: :forbidden
    end
  end

  def change_state(messages, from_state, to_state)
    messages.find_each do |message|
      if message.send(from_state) && message.session.token != session_token
        message.send(to_state)
      end
    end
  end
end
