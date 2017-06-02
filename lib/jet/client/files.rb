require 'zlib'
require 'stringio'

module Jet
  class Client
    # Files client
    class Files
      def initialize(client)
        @client = client
      end

      def upload_token
        @client.rest_get_with_token('/files/uploadToken')
      end

      def file_upload(url, body)
        headers = { 'x-ms-blob-type' => 'blockblob' }
        io = StringIO.new
        gz = Zlib::GzipWriter.new(io)
        gz.write(body)
        gz.close
        gzipped_body = io.string
        response = RestClient.put(url, gzipped_body, headers)
        @client.decode_json(response.body) if response.code == 200
      end

      def uploaded_files(url, file_type, file_name)
        headers = @client.token
        body = { url: url, file_type: file_type, file_name: file_name }
        response = RestClient.post("#{Jet::Client::API_URL}/files/uploaded", @client.encode_json(body), headers)
        @client.decode_json(response.body) if response.code == 200
      end

      def jet_file_id(file_id)
        @client.rest_get_with_token("/files/#{file_id}")
      end
    end
  end
end
