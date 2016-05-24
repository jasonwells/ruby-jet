require 'jet'
require 'oj'
require 'rest-client'

RSpec.describe Jet::Client, '#token' do
  context 'asks for token' do
    it 'returns token header' do
      response = double
      allow(response).to receive(:body) { '{"id_token":"notarealtoken", "token_type":"Bearer", "expires_on":"2015-01-01T00:00:00Z"}' }
      allow(response).to receive(:code) { 200 }
      submit_body = Oj.dump({ user: 'foo', pass: 'bar' }, mode: :compat)
      allow(RestClient).to receive(:post).with("#{Jet::Client::API_URL}/token", submit_body) { response }

      client = Jet::Client.new(api_user: 'foo', secret: 'bar')
      header = client.token
      expect(header).to eq(Authorization: 'Bearer notarealtoken')
    end
  end

  context 'asks for token with bad creds' do
    it 'raises 400 error' do
      submit_body = Oj.dump({ user: 'notreal', pass: 'badcreds' }, mode: :compat)
      allow(RestClient).to receive(:post)
        .with("#{Jet::Client::API_URL}/token", submit_body)
        .and_raise(RestClient::BadRequest)

      client = Jet::Client.new(api_user: 'notreal', secret: 'badcreds')
      expect { client.token }.to raise_error(RestClient::BadRequest)
    end
  end
end
