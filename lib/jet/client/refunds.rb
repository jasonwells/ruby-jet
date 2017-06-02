module Jet
  class Client
    # Refunds client
    class Refunds
      STATUSES = {
        created: 'created',
        processing: 'processing',
        accepted: 'accepted',
        rejected: 'rejected'
      }.freeze

      def initialize(client)
        @client = client
      end

      def create_merchant_initiated_refund(order_id, alt_refund_id, body = {})
        @client.rest_post_with_token("/refunds/#{order_id}/#{alt_refund_id}", body)
      end

      def check_refund_state(refund_authorization_id)
        @client.rest_get_with_token("/refunds/state/#{refund_authorization_id}")
      end

      def check_for_created_refunds(status)
        query_status = STATUSES[status]
        @client.rest_get_with_token("/refunds/#{query_status}")
      end
    end
  end
end
