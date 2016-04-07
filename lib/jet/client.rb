require 'rest-client'
require 'json'

class Jet::Client
  API_URL = 'https://merchant-api.jet.com/api'

  def initialize(config = {})
    @api_user = config[:api_user]
    @secret = config[:secret]
    @merchant_id = config[:merchant_id]
  end

  def token
    if not (@id_token and @token_type and @expires_on > Time.now)
      body = {
        user: @api_user,
        pass: @secret
      }
      response = RestClient.post("#{API_URL}/token", body.to_json)
      parsed_response = JSON.parse(response.body)
      @id_token = parsed_response['id_token']
      @token_type = parsed_response['token_type']
      @expires_on = Time.parse(parsed_response['expires_on'])
    end

    { Authorization: "#{@token_type} #{@id_token}" }
  end

  def rest_get_with_token(path, query_params = {})
    headers = token
    headers.merge!({ params: query_params }) unless query_params.empty?
    response = RestClient.get("#{API_URL}#{path}", headers)
    JSON.parse(response.body) if response.code == 200
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
end

require 'jet/client/orders'
require 'jet/client/returns'
require 'jet/client/products'
require 'jet/client/taxonomy'
require 'jet/client/files'
