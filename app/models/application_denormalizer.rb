class ApplicationDenormalizer

  attr_reader :app

  def initialize(app)
    @app = app
  end

  def to_hash
    %w[
      token
      name
      chats_count]
      .map { |method_name| [method_name, send(method_name)] }.to_h
  end

  def token
    app.token
  end

  def name
    app.name
  end

  def chats_count
    app.chats_count
  end
end
