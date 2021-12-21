class ChatDenormalizer

  attr_reader :c

  def initialize(c)
    @c = c
  end

  def to_hash
    %w[
      app_id
      number
      messages_count]
      .map { |method_name| [method_name, send(method_name)] }.to_h
  end

  def app_id
    c.app_id
  end

  def number
    c.number
  end

  def messages_count
    c.messages_count
  end

end
