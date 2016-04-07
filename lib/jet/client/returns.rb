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
    query_status = STATUSES[status]
    @client.rest_get_with_token("/returns/#{query_status}")
  end

  def get_return(return_url)
    @client.rest_get_with_token(return_url)
  end

  def get_return_by_id(return_id)
    @client.rest_get_with_token("/returns/state/#{return_id}")
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
