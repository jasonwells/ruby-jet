require 'jet'

RSpec.describe Jet::Client::Orders, '#update_inventory' do
  context 'update product inventory' do
    it 'returns 204 on success' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:patch)
        .with("#{Jet::Client::API_URL}/merchant-skus/fakesku/inventory", '{}', fake_header) { response }
      allow(response).to receive(:code) { 204 }
      allow(response).to receive(:body) { nil }

      inventory = client.products.update_inventory('fakesku', {})
      expect(inventory).to be_nil
    end
  end

  context 'update inventory for non-existant sku' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:patch)
        .with("#{Jet::Client::API_URL}/merchant-skus/badsku/inventory", '{}', fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.products.update_inventory('badsku', {}) }
        .to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#get_inventory' do
  context 'get product inventory' do
    it 'returns inventory' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/merchant-skus/fakesku/inventory", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"fulfillment_nodes":[]}' }

      inventory = client.products.get_inventory('fakesku')
      expect(inventory['fulfillment_nodes'].length).to eq 0
    end
  end

  context 'get inventory for non-existant sku' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/merchant-skus/badsku/inventory", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.products.get_inventory('badsku') }
        .to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#update_product' do
  context 'update product' do
    it 'returns 201 on success' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/merchant-skus/fakesku", '{}', fake_header) { response }
      allow(response).to receive(:code) { 201 }
      allow(response).to receive(:body) { nil }

      product = client.products.update_product('fakesku', {})
      expect(product).to be_nil
    end
  end

  context 'update product for with blank body' do
    it 'returns 400 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/merchant-skus/badsku", '""', fake_header)
        .and_raise(RestClient::BadRequest)

      expect { client.products.update_product('badsku', '') }
        .to raise_error RestClient::BadRequest
    end
  end
end

RSpec.describe Jet::Client::Orders, '#get_product' do
  context 'get product' do
    it 'returns product' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/merchant-skus/fakesku", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"product_title":"Fake Product"}' }

      inventory = client.products.get_product('fakesku')
      expect(inventory['product_title']).to eq 'Fake Product'
    end
  end

  context 'get product for non-existant sku' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/merchant-skus/badsku", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.products.get_product('badsku') }
        .to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#archive_sku' do
  context 'archive sku that exists' do
    it 'returns a 204 on success' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/merchant-skus/fakesku/status/archive", '{}', fake_header) { response }
      allow(response).to receive(:code) { 204 }
      allow(response).to receive(:body) { nil }

      archive = client.products.archive_sku('fakesku', {})
      expect(archive).to be_nil
    end
  end
end

RSpec.describe Jet::Client::Orders, '#update_price' do
  context 'update product price' do
    it 'returns 204 on success' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/merchant-skus/fakesku/price", '{}', fake_header) { response }
      allow(response).to receive(:code) { 204 }
      allow(response).to receive(:body) { nil }

      inventory = client.products.update_price('fakesku', {})
      expect(inventory).to be_nil
    end
  end

  context 'update price for non-existant sku' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/merchant-skus/badsku/price", '{}', fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.products.update_price('badsku', {}) }
        .to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#get_price' do
  context 'get product price' do
    it 'returns price' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/merchant-skus/fakesku/price", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"price": 12.6}' }

      inventory = client.products.get_price('fakesku')
      expect(inventory['price']).to eq 12.6
    end
  end

  context 'get price for non-existant sku' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/merchant-skus/badsku/price", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.products.get_price('badsku') }
        .to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#update_image' do
  context 'update product image' do
    it 'returns 204 on success' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/merchant-skus/fakesku/image", '{}', fake_header) { response }
      allow(response).to receive(:code) { 204 }
      allow(response).to receive(:body) { nil }

      inventory = client.products.update_image('fakesku', {})
      expect(inventory).to be_nil
    end
  end

  context 'update image for non-existant sku' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/merchant-skus/badsku/image", '{}', fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.products.update_image('badsku', {}) }
        .to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Orders, '#get_products' do
  context 'get products' do
    it 'returns product urls' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/merchant-skus", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"sku_urls": []}' }

      products = client.products.get_products
      expect(products['sku_urls'].length).to eq 0
    end
  end
end
