require 'jet'

RSpec.describe Jet, '#client' do
  context "asks for client" do
    it "returns client" do
      client = Jet.client
      expect(client).to be_a Jet::Client
    end
  end
end
