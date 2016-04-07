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
    query_status = STATUSES[status]
    @client.rest_get_with_token("/orders/#{query_status}")
  end

  def get_order(order_url)
    @client.rest_get_with_token(order_url)
  end

  def get_order_by_id(order_id)
    @client.rest_get_with_token("/orders/withoutShipmentDetail/#{order_id}")
  end

  def acknowledge_order(order_id, body = {})
    @client.rest_put_with_token("/orders/#{order_id}/acknowledge", body)
  end

  def ship_order(order_id, body = {})
    @client.rest_put_with_token("/orders/#{order_id}/shipped", body)
  end

  def get_directed_cancel
    @client.rest_get_with_token('/orders/directedCancel')
  end
end
