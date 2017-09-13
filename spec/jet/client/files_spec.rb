require 'jet'

RSpec.describe Jet::Client::Files, '#upload_token' do
  context 'get upload token' do
    it 'returns token information' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get).with("#{Jet::Client::API_URL}/files/uploadToken", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"url":"https://jetupload.blob.core.windows.net/merchant-files/dca10a71128940bf80aca9edee52e7cd?sv=2014-02-14&sr=b&sig=PCIQGWiwzHmdBeEQbFTnOeyAdGowKcQYbTg9OPIvEQo%3D&se=2014-10-15T22%3A23%3A28Z&sp=w","jet_file_id":"dca10a71128940bf80aca9edee52e7cd","expires_in_seconds":1800}' }

      upload_token = client.files.upload_token
      expect(upload_token['url']).to eq 'https://jetupload.blob.core.windows.net/merchant-files/dca10a71128940bf80aca9edee52e7cd?sv=2014-02-14&sr=b&sig=PCIQGWiwzHmdBeEQbFTnOeyAdGowKcQYbTg9OPIvEQo%3D&se=2014-10-15T22%3A23%3A28Z&sp=w'
      expect(upload_token['jet_file_id']).to eq 'dca10a71128940bf80aca9edee52e7cd'
      expect(upload_token['expires_in_seconds']).to eq 1800
    end
  end

  context 'get bad status upload token' do
    it 'returns 500 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/files/uploadToken", fake_header)
        .and_raise(RestClient::InternalServerError)

      expect { client.files.upload_token }.to raise_error RestClient::InternalServerError
    end
  end
end

RSpec.describe Jet::Client::Files, '#file_upload' do
  context 'upload file' do
    it 'returns file upload success' do
      client = Jet.client

      response = double
      fake_header = { 'x-ms-blob-type' => 'blockblob' }
      fake_url = 'https://jetupload.blob.core.windows.net/merchant-files/dca10a71128940bf80aca9edee52e7cd?sv=2014-02-14&sr=b&sig=PCIQGWiwzHmdBeEQbFTnOeyAdGowKcQYbTg9OPIvEQo%3D&se=2014-10-15T22%3A23%3A28Z&sp=w'
      fake_body = '{"fake":"json"}'
      allow(RestClient).to receive(:put).with(fake_url, anything, fake_header) { response }
      allow(response).to receive(:code) { 201 }
      allow(response).to receive(:body) { '{}' }

      upload_response = client.files.file_upload(fake_url, fake_body)
      expect(upload_response[:status]).to eq :success
    end
  end

  context 'get bad status upload file' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { 'x-ms-blob-type' => 'blockblob' }
      fake_url = 'https://jetupload.blob.core.windows.net/merchant-files/dca10a71128940bf80aca9edee52e7cd?sv=2014-02-14&sr=b&sig=PCIQGWiwzHmdBeEQbFTnOeyAdGowKcQYbTg9OPIvEQo%3D&se=2014-10-15T22%3A23%3A28Z&sp=w'
      fake_body = '{"fake":"json"}'
      allow(RestClient).to receive(:put)
        .with(fake_url, anything, fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.files.file_upload(fake_url, fake_body) }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Files, '#uploaded_files' do
  context 'notify jet of uploaded file' do
    it 'returns file upload status' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      fake_url = 'https://jetupload.blob.core.windows.net/merchant-files/dca10a71128940bf80aca9edee52e7cd?sv=2014-02-14&sr=b&sig=PCIQGWiwzHmdBeEQbFTnOeyAdGowKcQYbTg9OPIvEQo%3D&se=2014-10-15T22%3A23%3A28Z&sp=w'
      fake_file_type = 'Inventory'
      fake_file_name = 'inventory.json.gz'
      allow(RestClient).to receive(:post).with("#{Jet::Client::API_URL}/files/uploaded", anything, fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"url":"https://jetupload.blob.core.windows.net/merchant-files/dca10a71128940bf80aca9edee52e7cd?sv=2014-02-14&sr=b&sig=PCIQGWiwzHmdBeEQbFTnOeyAdGowKcQYbTg9OPIvEQo%3D&se=2014-10-15T22%3A23%3A28Z&sp=w", "file_name":"inventory.json.gz", "received":"2016-04-06T17:25:06.4214060Z", "file_type":"Inventory", "status":"Acknowledged", "jet_file_id":"fakejetfileid"}' }

      status = client.files.uploaded_files(fake_url, fake_file_type, fake_file_name)
      expect(status['url']).to eq fake_url
      expect(status['file_type']).to eq fake_file_type
      expect(status['file_name']).to eq fake_file_name
      expect(status['status']).to eq 'Acknowledged'
    end
  end

  context 'get bad location for file uploaded' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      fake_url = 'https://jetupload.blob.core.windows.net/merchant-files/dca10a71128940bf80aca9edee52e7cd?sv=2014-02-14&sr=b&sig=PCIQGWiwzHmdBeEQbFTnOeyAdGowKcQYbTg9OPIvEQo%3D&se=2014-10-15T22%3A23%3A28Z&sp=w'
      fake_file_type = 'Inventory'
      fake_file_name = 'inventory.json.gz'
      allow(RestClient).to receive(:post)
        .with("#{Jet::Client::API_URL}/files/uploaded", anything, fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.files.uploaded_files(fake_url, fake_file_type, fake_file_name) }.to raise_error RestClient::ResourceNotFound
    end
  end
end

RSpec.describe Jet::Client::Files, '#jet_file_id' do
  context 'upload file' do
    it 'returns file upload success' do
      client = Jet.client

      response = double
      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      fake_jet_file_id = 'fakejetfileid'
      allow(RestClient).to receive(:get).with("#{Jet::Client::API_URL}/files/#{fake_jet_file_id}", fake_header) { response }
      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { '{"url":"https://jetupload.blob.core.windows.net/merchant-files/dca10a71128940bf80aca9edee52e7cd?sv=2014-02-14&sr=b&sig=PCIQGWiwzHmdBeEQbFTnOeyAdGowKcQYbTg9OPIvEQo%3D&se=2014-10-15T22%3A23%3A28Z&sp=w", "file_name":"inventory.json.gz", "received":"2016-04-06T17:25:06.4214060Z", "file_type":"Inventory", "status":"Acknowledged", "jet_file_id":"fakejetfileid"}' }

      status = client.files.jet_file_id(fake_jet_file_id)
      expect(status['jet_file_id']).to eq fake_jet_file_id
    end
  end

  context 'get bad status upload file' do
    it 'returns 404 error' do
      client = Jet.client

      fake_header = { Authorization: 'Bearer notarealtoken' }
      allow(client).to receive(:token) { fake_header }
      fake_jet_file_id = 'fakejetfileid'
      allow(RestClient).to receive(:get)
        .with("#{Jet::Client::API_URL}/files/#{fake_jet_file_id}", fake_header)
        .and_raise(RestClient::ResourceNotFound)

      expect { client.files.jet_file_id(fake_jet_file_id) }.to raise_error RestClient::ResourceNotFound
    end
  end
end
