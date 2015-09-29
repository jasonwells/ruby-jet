require 'jet'

RSpec.describe Jet, "#test" do
  context "default test" do
    it "returns test string" do
      test_string = Jet.test
      expect(test_string).to eq 'Hello, gem test!'
    end
  end
end
