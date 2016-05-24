require 'rest-client'

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

  def complete_return(return_id, body = {})
    @client.rest_put_with_token("/returns/#{return_id}/complete", body)
  end
end
