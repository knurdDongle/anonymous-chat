class ChatChannel < ApplicationCable::Channel
  def subscribed
     stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def reply(data)
    session_token = data['session_token']
    message = data['message']

    @session = Session.find_by(token: session_token)
    @session.messages.create(message: message)
  end
end
