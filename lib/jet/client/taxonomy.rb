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

  def get_node(node_url)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}#{node_url}", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_node_attributes(node_url)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}#{node_url}/attributes", headers)
    JSON.parse(response.body) if response.code == 200
  end
end
