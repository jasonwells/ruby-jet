# Jet API module
module Jet
  def self.client(credentials = {}, raw_token = {})
    Client.new(credentials, raw_token)
  end
end

require 'jet/client'
