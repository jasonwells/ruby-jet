require 'rest-client'
require 'json'

class Jet::Client::Returns

  STATUSES = {
    jet_refunded: 'Jet refunded',
    created: 'created',
    inprogress: 'inprogress',
    completed_by_merchant: 'completed by merchant',
  }

  def initialize(client)
    @client = client
  end

  def get_returns(status = :created)
    headers = @client.get_token
    query_status = STATUSES[status]
    response = RestClient.get("#{Jet::Client::API_URL}/returns/#{query_status}", headers)
    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end

  def get_return(return_url)
    headers = @client.get_token
    response = RestClient.get("#{Jet::Client::API_URL}#{return_url}", headers)
    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end

  def get_return_by_id(return_id)
    headers = @client.get_token
    response = RestClient.get("#{Jet::Client::API_URL}/returns/state/#{return_id}", headers)
    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end

  def acknowledge_return(return_id, body = {})
    headers = @client.get_token
    response = RestClient.put("#{Jet::Client::API_URL}/returns/#{return_id}/acknowledge", body.to_json, headers)
    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end

  def complete_return(return_id, body = {})
    headers = @client.get_token
    response = RestClient.put("#{Jet::Client::API_URL}/returns/#{return_id}/complete", body.to_json, headers)
    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end
end
