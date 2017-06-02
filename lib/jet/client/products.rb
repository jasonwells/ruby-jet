module Jet
  class Client
    # Products client
    class Products
      def initialize(client)
        @client = client
      end

      def update_inventory(merchant_sku, body = {})
        @client.rest_put_with_token("/merchant-skus/#{merchant_sku}/inventory", body)
      end

      def get_inventory(merchant_sku)
        @client.rest_get_with_token("/merchant-skus/#{merchant_sku}/inventory")
      end

      def update_product(merchant_sku, body = {})
        @client.rest_put_with_token("/merchant-skus/#{merchant_sku}", body)
      end

      def get_product(merchant_sku)
        @client.rest_get_with_token("/merchant-skus/#{merchant_sku}")
      end

      def update_price(merchant_sku, body = {})
        @client.rest_put_with_token("/merchant-skus/#{merchant_sku}/price", body)
      end

      def get_price(merchant_sku)
        @client.rest_get_with_token("/merchant-skus/#{merchant_sku}/price")
      end

      def update_image(merchant_sku, body = {})
        @client.rest_put_with_token("/merchant-skus/#{merchant_sku}/image", body)
      end

      def get_products(params = {})
        @client.rest_get_with_token('/merchant-skus', params)
      end
    end
  end
end
