require 'rest-client'
require 'oj'

module Jet
  # Jet API Client
  class Client
    API_URL = 'https://merchant-api.jet.com/api'.freeze

    def initialize(config = {})
      @api_user = config[:api_user]
      @secret = config[:secret]
      @merchant_id = config[:merchant_id]
    end

    def encode_json(data)
      Oj.dump(data, mode: :compat)
    end

    def decode_json(json)
      Oj.load(json)
    end

    def token
      unless @id_token && @token_type && @expires_on > Time.now
        body = { user: @api_user, pass: @secret }
        response = RestClient.post("#{API_URL}/token", encode_json(body))
        parsed_response = decode_json(response.body)
        @id_token = parsed_response['id_token']
        @token_type = parsed_response['token_type']
        @expires_on = Time.parse(parsed_response['expires_on'])
      end

      { Authorization: "#{@token_type} #{@id_token}" }
    end

    def rest_get_with_token(path, query_params = {})
      headers = token
      headers[:params] = query_params unless query_params.empty?
      response = RestClient.get("#{API_URL}#{path}", headers)
      decode_json(response.body) if response.code == 200
    end

    def rest_put_with_token(path, body = {})
      headers = token
      response = RestClient.put("#{API_URL}#{path}", encode_json(body), headers)
      decode_json(response.body) if response.code == 200
    end

    def rest_post_with_token(path, body = {})
      headers = token
      response = RestClient.post("#{API_URL}#{path}", encode_json(body), headers)
      decode_json(response.body) if response.code == 201
    end

    def orders
      Orders.new(self)
    end

    def returns
      Returns.new(self)
    end

    def products
      Products.new(self)
    end

    def taxonomy
      Taxonomy.new(self)
    end

    def files
      Files.new(self)
    end

    def refunds
      Refunds.new(self)
    end
  end
end

require 'jet/client/orders'
require 'jet/client/returns'
require 'jet/client/products'
require 'jet/client/taxonomy'
require 'jet/client/files'
require 'jet/client/refunds'
require 'jet/client/returns'
