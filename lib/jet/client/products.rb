require 'rest-client'
require 'json'

class Jet::Client::Products
  def initialize(client)
    @client = client
  end

  def update_inventory(merchant_sku, body = {})
    headers = @client.token
    response = RestClient.put("#{Jet::Client::API_URL}/merchant-skus/#{merchant_sku}/inventory", body.to_json, headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_inventory(merchant_sku)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/merchant-skus/#{merchant_sku}/inventory", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def update_product(merchant_sku, body = {})
    headers = @client.token
    response = RestClient.put("#{Jet::Client::API_URL}/merchant-skus/#{merchant_sku}", body.to_json, headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_product(merchant_sku)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/merchant-skus/#{merchant_sku}", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def update_price(merchant_sku, body = {})
    headers = @client.token
    response = RestClient.put("#{Jet::Client::API_URL}/merchant-skus/#{merchant_sku}/price", body.to_json, headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_price(merchant_sku)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/merchant-skus/#{merchant_sku}/price", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def update_image(merchant_sku, body = {})
    headers = @client.token
    response = RestClient.put("#{Jet::Client::API_URL}/merchant-skus/#{merchant_sku}/image", body.to_json, headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_products(params = {})
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/merchant-skus", headers.merge({ params: params }))
    JSON.parse(response.body) if response.code == 200
  end
end

