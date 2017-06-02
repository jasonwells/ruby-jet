module Jet
  class Client
    # Orders client
    class Orders
      STATUSES = {
        created: 'created',
        ready: 'ready',
        acknowledged: 'acknowledged',
        inprogress: 'inprogress',
        complete: 'complete'
      }

      def initialize(client)
        @client = client
      end

      def get_orders(status = :ready, params = {})
        query_status = STATUSES[status]
        @client.rest_get_with_token("/orders/#{query_status}", params)
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

      def tag_order(order_id, tag)
        body = { tag: tag } if tag
        @client.rest_put_with_token("/orders/#{order_id}/tag", body)
      end

      def check_for_tagged_orders(status, tag, with_tag = true)
        query_status = STATUSES[status]
        query_with_tag = with_tag ? true : false
        @client.rest_get_with_token("/orders/#{query_status}/#{tag}/#{query_with_tag}")
      end
    end
  end
end
