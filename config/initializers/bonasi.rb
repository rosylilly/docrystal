Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV['BONSAI_URL']) if ENV['BONSAI_URL']
