require 'jet'

RSpec.describe Jet::Client::Taxonomy, '#get_links' do
  context 'get links' do
    it 'returns empty list of nodes' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken', params: { limit: 0, offset: 0 }}
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get).with("#{Jet::Client::API_URL}/taxonomy/links/v1", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"node_urls": []}' }

      links = client.taxonomy.get_links(0, 0)
      expect(links['node_urls'].length).to eq 0
    end
  end

  context 'get bad status returns' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken', params: { limit: 0, offset: 0 }}
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/taxonomy/links/v1", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.taxonomy.get_links(0, 0) }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Taxonomy, '#get_node' do
  context 'get taxonomy node' do
    it 'returns node' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/taxonomy/nodes/fakenodeid", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"jet_node_id": "fakenodeid" }' }

      node = client.taxonomy.get_node('/taxonomy/nodes/fakenodeid')
      expect(node['jet_node_id']).to eq 'fakenodeid'
    end
  end

  context 'get node for non-existent node_url' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/taxonomy/nodes/badnodeid", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.taxonomy.get_node('/taxonomy/nodes/badnodeid') }
        .to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Taxonomy, '#get_node_attributes' do
  context 'get taxonomy node attributes' do
    it 'returns node attributes' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/taxonomy/nodes/fakenodeid/attributes", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"attributes": [] }' }

      attributes = client.taxonomy.get_node_attributes('/taxonomy/nodes/fakenodeid')
      expect(attributes['attributes'].length).to eq 0
    end
  end

  context 'get node attributes for non-existent node_url' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/taxonomy/nodes/badnodeid/attributes", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.taxonomy.get_node_attributes('/taxonomy/nodes/badnodeid') }
        .to raise_error RestClient::ResourceNotFound
    end
  end
end
