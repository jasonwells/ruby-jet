require 'jet'

RSpec.describe Jet::Client::Refunds, '#create_merchant_initiated_refund' do
  context 'create refund' do
    it 'returns refund_authorization_id' do
      client = Jet.client

      order_id = 123546789
      alt_refund_id = '123546789-refund'
      body = {}

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:post).with("#{Jet::Client::API_URL}/refunds/#{order_id}/#{alt_refund_id}", '{}', fake_header) { response }
      allow(response).to receive(:code) { 201 }
      allow(response).to receive(:body) { '{"refund_authorization_id": "123456789","refund_status":"created"}' }

      refund = client.refunds.create_merchant_initiated_refund(order_id, alt_refund_id, body)
      expect(refund['refund_authorization_id']).to eq '123456789'
      expect(refund['refund_status']).to eq 'created'
    end
  end
end

RSpec.describe Jet::Client::Refunds, '#check_refund_state' do
  context 'get refund by refund_authorization_id' do
    it 'returns state of refund' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      refund_authorization_id = '1234567890987654321'
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/refunds/state/#{refund_authorization_id}", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { %q(
        {
          "alt_refund_id": "1292142451",
          "refund_authorization_id": "1234567890987654321",
          "reference_order_id": "982307409183459145",
          "refund_status": "accepted",
          "merchant_order_id": "9b13bdd68c314d1b9c8b93277dea4da1",
          "reference_merchant_order_id": "1234567890",
          "alt_order_id": "12345678",
          "items": [
            {
              "order_item_id": "1123456789",
              "alt_order_item_id": "A1223456",
              "total_quantity_returned": 1,
              "order_return_refund_qty": 1,
              "refund_reason": "better price available",
              "refund_feedback": "item damaged",
              "notes": "This is where the notes go",
              "refund_amount": {
                "principal": 12.75,
                "tax": 0.9,
                "shipping_cost": 1.0,
                "shipping_tax": 0.07
              }
            }
          ]
        }
      ) }

      refund = client.refunds.check_refund_state(refund_authorization_id)
      expect(refund['refund_authorization_id']).to eq '1234567890987654321'
    end
  end
end

RSpec.describe Jet::Client::Refunds, '#check_for_created_refunds' do
  context 'check for created refunds' do
    it 'returns created refunds' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/refunds/created", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"sku_urls": ["refunds/1289076123041324","refunds/9087132460512356"]}' }

      refunds = client.refunds.check_for_created_refunds(:created)
      expect(refunds['sku_urls'].length).to eq 2
    end
  end
end
