require 'jet'

RSpec.describe Jet::Client::Returns, "#get_returns" do
  context "get created returns" do
    it "returns empty orders hash" do
      client = Jet.client

      response = double
      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:get).with("#{Jet::Client::API_URL}/returns/created", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"return_urls": []}' }

      returns = client.returns.get_returns
      expect(returns['return_urls'].length).to eq 0
    end
  end

  context "get bad status returns" do
    it "returns 404 error" do
      client = Jet.client

      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/returns/", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.returns.get_returns(:bogus) }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Returns, "#get_return" do
  context "get return by url" do
    it "returns return" do
      client = Jet.client

      response = double
      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/returns/state/fakeid", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"merchant_return_authorization_id": "fakeid"}' }

      returns = client.returns.get_return('/returns/state/fakeid')
      expect(returns['merchant_return_authorization_id']).to eq 'fakeid'
    end
  end

  context "get return not present" do
    it "returns 404 error" do
      client = Jet.client

      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/returns/state/badid", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.returns.get_return('/returns/state/badid') }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Returns, "#get_return_by_id" do
  context "get return by id" do
    it "returns return" do
      client = Jet.client

      response = double
      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/returns/state/fakeid", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"merchant_return_authorization_id": "fakeid"}' }

      returns = client.returns.get_return_by_id('fakeid')
      expect(returns['merchant_return_authorization_id']).to eq 'fakeid'
    end
  end

  context "get return not present" do
    it "returns 404 error" do
      client = Jet.client

      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/returns/state/badid", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.returns.get_return_by_id('badid') }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Returns, "#acknowledge_return" do
  context "acknowledges return" do
    it "returns success" do
      client = Jet.client

      response = double
      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/returns/fakeid/acknowledge", '{}', fake_header) { response }
      allow(response).to receive(:code) { 201 }
      allow(response).to receive(:body) { nil }

      ack = client.returns.acknowledge_return('fakeid')
      expect(response.code).to eq 201
      expect(ack).to be_nil
    end
  end

  context "acknowledges return not present" do
    it "returns 404 error" do
      client = Jet.client

      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/returns/badid/acknowledge", '{}', fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.returns.acknowledge_return('badid') }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Returns, "#complete_return" do
  context "sends order shipped notification" do
    it "returns success" do
      client = Jet.client

      response = double
      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/returns/fakeid/complete", '{}', fake_header) { response }
      allow(response).to receive(:code) { 201 }
      allow(response).to receive(:body) { nil }

      completed = client.returns.complete_return('fakeid')
      expect(response.code).to eq 201
      expect(completed).to be_nil
    end
  end

  context "sends return complete notification not present" do
    it "returns 404 error" do
      client = Jet.client

      fake_header = {Authorization: 'Bearer notarealtoken'}
      allow(client).to receive(:get_token) { fake_header }
      allow(RestClient).to receive(:put)
        .with("#{Jet::Client::API_URL}/returns/badid/complete", '{}', fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.returns.complete_return('badid') }.to raise_error RestClient::ResourceNotFound
    end
  end
end
