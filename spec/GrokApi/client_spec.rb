describe GrokApi::Client do
  let(:logger) { true }

  describe "#start_conversation" do
    it "gets a conversationId" do
      client = GrokApi::Client.new(logger: logger)
      VCR.use_cassette("get_conversation3") do
        expect(client.start_conversation).to eq("1737602637606903808")
      end
    end
  end
end
