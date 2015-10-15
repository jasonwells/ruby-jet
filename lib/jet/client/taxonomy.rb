require 'rest-client'
require 'json'

class Jet::Client::Taxonomy
  def initialize(client)
    @client = client
  end

  def get_links(limit, offset, version = "v1")
    headers = @client.token
    params = { limit: limit, offset: offset }
    response = RestClient.get("#{Jet::Client::API_URL}/taxonomy/links/#{version}", headers.merge({ params: params }))
    JSON.parse(response.body) if response.code == 200
  end

  def get_node(node_id)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/taxonomy/nodes/#{node_id}", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_node_attributes(node_id)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/taxonomy/nodes/#{node_id}/attributes", headers)
    JSON.parse(response.body) if response.code == 200
  end
end
