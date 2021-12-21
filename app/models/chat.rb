require 'elasticsearch/model'
class Chat < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(_options = {})
    ChatDenormalizer.new(self).to_hash
  end

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :id, type: :integer
      indexes :number, type: :integer
      indexes :app_id, type: :integer
    end
  end

end
