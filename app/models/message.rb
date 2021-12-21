require 'elasticsearch/model'
class Message < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(_options = {})
    MessageDenormalizer.new(self).to_hash
  end

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :chat_id, type: :integer
      indexes :number, type: :integer
      indexes :body, type: :text
    end
  end

end
