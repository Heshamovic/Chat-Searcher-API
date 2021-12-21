require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new host: 'http://elastic:TCwDxjATcPOJA0qBQKAp@localhost:9200',
                                                        transport_options: { request: { timeout: 15 } }

