require 'jet'

RSpec.describe Jet::Client::Orders, '#get_orders' do
  context 'get ready orders' do
    it 'returns empty orders hash' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get).with("#{Jet::Client::API_URL}/orders/ready", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"order_urls": []}' }

      orders = client.orders.get_orders
      expect(orders['order_urls'].length).to eq 0
    end
  end

  context 'get bad status orders' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/orders/", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.orders.get_orders(:bogus) }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#get_order' do
  context 'get order by url' do
    it 'returns order' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/orders/withoutShipmentDetail/fakeid", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"merchant_order_id": "fakeid"}' }

      orders = client.orders.get_order('/orders/withoutShipmentDetail/fakeid')
      expect(orders['merchant_order_id']).to eq 'fakeid'
    end
  end

  context 'get order not present' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/orders/withoutShipmentDetail/badid", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.orders.get_order('/orders/withoutShipmentDetail/badid') }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#get_order_by_id' do
  context 'get order by id' do
    it 'returns order' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/orders/withoutShipmentDetail/fakeid", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"merchant_order_id": "fakeid"}' }

      orders = client.orders.get_order_by_id('fakeid')
      expect(orders['merchant_order_id']).to eq 'fakeid'
    end
  end

  context 'get order not present' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/orders/withoutShipmentDetail/badid", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.orders.get_order_by_id('badid') }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#acknowledge_order' do
  context 'acknowledges order' do
    it 'returns success' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/orders/fakeid/acknowledge", '{}', fake_header) { response }
      allow(response).to receive(:code) { 201 }
      allow(response).to receive(:body) { nil }

      ack = client.orders.acknowledge_order('fakeid')
      expect(response.code).to eq 201
      expect(ack).to be_nil
    end
  end

  context 'acknowledges order not present' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/orders/badid/acknowledge", '{}', fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.orders.acknowledge_order('badid') }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#ship_order' do
  context 'sends order shipped notification' do
    it 'returns success' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/orders/fakeid/shipped", '{}', fake_header) { response }
      allow(response).to receive(:code) { 201 }
      allow(response).to receive(:body) { nil }

      shipped = client.orders.ship_order('fakeid')
      expect(response.code).to eq 201
      expect(shipped).to be_nil
    end
  end

  context 'sends order shipped notification not present' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/orders/badid/shipped", '{}', fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.orders.ship_order('badid') }.to raise_error RestClient::ResourceNotFound
    end
  end
end
