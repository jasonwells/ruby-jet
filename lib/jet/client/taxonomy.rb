module Jet
  class Client
    # Taxonomy client
    class Taxonomy
      def initialize(client)
        @client = client
      end

      def get_links(limit, offset, version = 'v1')
        params = { limit: limit, offset: offset }
        @client.rest_get_with_token("/taxonomy/links/#{version}", params)
      end

      def get_node(node_url)
        @client.rest_get_with_token(node_url)
      end

      def get_node_attributes(node_url)
        @client.rest_get_with_token("#{node_url}/attributes")
      end
    end
  end
end
