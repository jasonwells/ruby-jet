require 'rest-client'
require 'json'

class Jet::Client::Returns

  STATUSES = {
    created: 'created',
    acknowledged: 'acknowledged',
    refund_customer_without_return: 'refund%20customer%20without%20return',
    completed_by_merchant: 'completed%20by%20merchant',
  }

  def initialize(client)
    @client = client
  end

  def get_returns(status = :created)
    headers = @client.token
    query_status = STATUSES[status]
    response = RestClient.get("#{Jet::Client::API_URL}/returns/#{query_status}", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_return(return_url)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}#{return_url}", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_return_by_id(return_id)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/returns/state/#{return_id}", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def acknowledge_return(return_id, body = {})
    headers = @client.token
    response = RestClient.put("#{Jet::Client::API_URL}/returns/#{return_id}/acknowledge", body.to_json, headers)
    JSON.parse(response.body) if response.code == 200
  end

  def complete_return(return_id, body = {})
    headers = @client.token
    response = RestClient.put("#{Jet::Client::API_URL}/returns/#{return_id}/complete", body.to_json, headers)
    JSON.parse(response.body) if response.code == 200
  end
end
