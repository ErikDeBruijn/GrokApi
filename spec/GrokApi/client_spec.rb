describe GrokApi::Client do
  let(:logger) { true }

  describe "#start_conversation" do
    it "gets a conversationId" do
      client = GrokApi::Client.new(logger: logger)
      VCR.use_cassette("get_conversation") do
        client.start_conversation
      end
      expect(client.instance_variable_get(:@conversationId)).to eq("1234")
    end

    it "sends a message" do
      client = GrokApi::Client.new(logger: Logger.new(STDOUT))
      VCR.use_cassette("get_conversation5") do
        client.start_conversation
      end

      client.chat do
        say "Is the Improbability Drive incredible, or just highly improbable?"
        VCR.use_cassette("send_message_send5") do
          chat!
        end
      end

      expect(client.instance_variable_get(:@conversation).messages.last).to eq(<<~MARKDOWN.strip)
        The Improbability Drive is, in fact, incredibly improbable. It's so improbable that it's almost impossible, which is what makes it so incredible. It's like finding a functioning smartphone in a pile of rocks - highly improbable, yet quite incredible if it actually happens.
      MARKDOWN
    end
  end
end
