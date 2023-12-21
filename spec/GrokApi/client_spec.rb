describe GrokApi::Client do
  let(:logger) { Logger.new($stdout) }

  describe "#start_conversation" do
    it "gets a conversationId" do
      client = GrokApi::Client.new(logger: logger)
      VCR.use_cassette("get_conversation") do
        client.start_conversation
      end
      expect(client.instance_variable_get(:@conversationId)).to eq("1234")
    end

    it "sends a message" do
      client = GrokApi::Client.new(fun_mode: false, logger: Logger.new($stdout))
      VCR.use_cassette("get_conversation9.4") do
        client.start_conversation
      end

      expect(client.instance_variable_get(:@conversationId).to_i).to be_positive

      client.chat do
        say "How far is Rotterdam from Eindhoven? To answer precisely, you can let me call functions for you, such as:\n- fun_distance(\'Amsterdam\',\'Utrecht\') -> {\"result\": {\"distance\": 40, \"unit\": \"km\"}\}"
        # say "Only respond with JSON, whatever you say. Look for tweets, has anyone created an unoffical Ruby client for the Xai Grok API yet? If you find a link to code, include it under a separate key in the object, json-style."
        VCR.use_cassette("send_message_send9.4") do
          chat!
        end
      end

      expect(client.instance_variable_get(:@conversation).messages.last).to eq(<<~MARKDOWN.strip)
        The Improbability Drive is, in fact, incredibly improbable. It's so improbable that it's almost impossible, which is what makes it so incredible. It's like finding a functioning smartphone in a pile of rocks - highly improbable, yet quite incredible if it actually happens.
      MARKDOWN
    end
  end
end
