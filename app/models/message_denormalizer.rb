class MessageDenormalizer

  attr_reader :message

  def initialize(message)
    @message = message
  end

  def to_hash
    %w[
      chat_id
      body
      number]
      .map { |method_name| [method_name, send(method_name)] }.to_h
  end

  def chat_id
    message.chat_id
  end

  def body
    message.body
  end

  def number
    message.number
  end
end
