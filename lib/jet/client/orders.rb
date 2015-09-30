require 'rest-client'
require 'json'

class Jet::Client::Orders

  STATUSES = {
    created: 'created',
    ready: 'ready',
    acknowledged: 'acknowledged',
    inprogress: 'inprogress',
    complete: 'complete',
  }

  def initialize(client)
    @client = client
  end

  def get_orders(status = :ready)
    headers = @client.get_token
    query_status = STATUSES[status]
    response = RestClient.get("#{Jet::Client::API_URL}/orders/#{query_status}", headers)
    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end

  def get_order(order_url)
    headers = @client.get_token
    response = RestClient.get("#{Jet::Client::API_URL}#{order_url}", headers)
    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end

  def get_order_by_id(order_id)
    headers = @client.get_token
    response = RestClient.get("#{Jet::Client::API_URL}/orders/withoutShipmentDetail/#{order_id}", headers)
    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end
end
