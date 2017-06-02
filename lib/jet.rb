# Jet API module
module Jet
  def self.client(credentials = {})
    Client.new(credentials)
  end
end

require 'jet/client'
