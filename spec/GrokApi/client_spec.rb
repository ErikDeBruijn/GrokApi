describe GrokApi::Client do
  let(:logger) { Logger.new($stdout) }

  describe "#start_conversation" do
    it "gets a conversationId" do
      stub_conversation_id
      client = GrokApi::Client.new(logger: logger)
      client.start_conversation
      expect(client.instance_variable_get(:@conversationId)).to eq("1234")
    end

    it "sends a message" do
      stub_conversation_id

      stub_request(:post, "https://api.twitter.com/2/grok/add_response.json")
        .with(
          body: "{\"responses\":[{\"message\":\"Is the Improbability Drive incredible, or just highly improbable?\",\"sender\":1}],\"systemPromptName\":\"\",\"conversationId\":\"1234\"}",
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "text/plain;charset=UTF-8",
            "Dnt" => "1",
            "Referer" => "https://twitter.com/",
            "Sec-Ch-Ua" => '"Not_A Brand";v="8", "Chromium";v="120"',
            "Sec-Ch-Ua-Mobile" => "?0",
            "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "X-Twitter-Client-Language" => "en"
          }
        )
        .to_return(
          status: 200,
          headers: {
            "Date" => "Thu, 21 Dec 2023 14:40:15 GMT",
            "Server" => "tsa_b",
            "Cache-Control" => "no-cache, no-store, max-age=0",
            "Strict-Transport-Security" => "max-age=631138519",
            "Transfer-Encoding" => "chunked"
          },
          body: <<~JSONLINES
            {"result":{"sender":"ASSISTANT","message":"The Impro","query":""}}
            {"result":{"sender":"ASSISTANT","message":"bability","query":""}}
            {"result":{"sender":"ASSISTANT","message":" Drive is","query":""}}
            {"result":{"sender":"ASSISTANT","message":" a fictional","query":""}}
            {"result":{"sender":"ASSISTANT","message":" concept from","query":""}}
            {"result":{"sender":"ASSISTANT","message":" Douglas Adams","query":""}}
            {"result":{"sender":"ASSISTANT","message":"'s","query":""}}
            {"result":{"sender":"ASSISTANT","message":" \\"The","query":""}}
            {"result":{"sender":"ASSISTANT","message":" Hitchh","query":""}}
            {"result":{"sender":"ASSISTANT","message":"iker'","query":""}}
            {"result":{"sender":"ASSISTANT","message":"s Guide","query":""}}
            {"result":{"sender":"ASSISTANT","message":" to the","query":""}}
            {"result":{"sender":"ASSISTANT","message":" Galaxy\\"","query":""}}
            {"result":{"sender":"ASSISTANT","message":" series.","query":""}}
            {"result":{"sender":"ASSISTANT","message":" In the","query":""}}
            {"result":{"sender":"ASSISTANT","message":" context of","query":""}}
            {"result":{"sender":"ASSISTANT","message":" the story","query":""}}
            {"result":{"sender":"ASSISTANT","message":", it","query":""}}
            {"result":{"sender":"ASSISTANT","message":" is an","query":""}}
            {"result":{"sender":"ASSISTANT","message":" incredible device","query":""}}
            {"result":{"sender":"ASSISTANT","message":" that allows","query":""}}
            {"result":{"sender":"ASSISTANT","message":" a spaceship","query":""}}
            {"result":{"sender":"ASSISTANT","message":" to pass","query":""}}
            {"result":{"sender":"ASSISTANT","message":" through every","query":""}}
            {"result":{"sender":"ASSISTANT","message":" point in","query":""}}
            {"result":{"sender":"ASSISTANT","message":" the Universe","query":""}}
            {"result":{"sender":"ASSISTANT","message":" simultaneously.","query":""}}
            {"result":{"sender":"ASSISTANT","message":" However,","query":""}}
            {"result":{"sender":"ASSISTANT","message":" as it","query":""}}
            {"result":{"sender":"ASSISTANT","message":" is a","query":""}}
            {"result":{"sender":"ASSISTANT","message":" fictional creation","query":""}}
            {"result":{"sender":"ASSISTANT","message":", it","query":""}}
            {"result":{"sender":"ASSISTANT","message":" is also","query":""}}
            {"result":{"sender":"ASSISTANT","message":" highly improbable","query":""}}
            {"result":{"sender":"ASSISTANT","message":" in the","query":""}}
            {"result":{"sender":"ASSISTANT","message":" real world","query":""}}
            {"result":{"sender":"ASSISTANT","message":".","query":""}}
            {"userChatItemId":"1737845452014309376","agentChatItemId":"1737845474835517440"}
          JSONLINES
      )

      client = GrokApi::Client.new(fun_mode: false, logger: Logger.new($stdout))
      client.start_conversation

      expect(client.instance_variable_get(:@conversationId).to_i).to be_positive

      client.chat do
        say "Is the Improbability Drive incredible, or just highly improbable?"
        chat!
      end

      expect(client.instance_variable_get(:@conversation).messages.last["message"]).to eq(<<~MARKDOWN.strip)
        The Improbability Drive is a fictional concept from Douglas Adams's "The Hitchhiker's Guide to the Galaxy" series. In the context of the story, it is an incredible device that allows a spaceship to pass through every point in the Universe simultaneously. However, as it is a fictional creation, it is also highly improbable in the real world.
      MARKDOWN
    end

    it "sends subsequent messages" do
      stub_conversation_id
      stub_request(:post, "https://api.twitter.com/2/grok/add_response.json")
        .with(
          body: '{"responses":[{"message":"Is the Improbability Drive incredible, or just highly improbable?","sender":1}],"systemPromptName":"fun","conversationId":"1234"}',
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "text/plain;charset=UTF-8",
            "Dnt" => "1",
            "Referer" => "https://twitter.com/",
            "Sec-Ch-Ua" => '"Not_A Brand";v="8", "Chromium";v="120"',
            "Sec-Ch-Ua-Mobile" => "?0",
            "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "X-Twitter-Client-Language" => "en"
          }
        )
        .to_return(
          status: 200,
          headers: {
            "Date" => "Thu, 21 Dec 2023 14:40:15 GMT",
            "Server" => "tsa_b",
            "Cache-Control" => "no-cache, no-store, max-age=0",
            "Strict-Transport-Security" => "max-age=631138519",
            "Transfer-Encoding" => "chunked"
          },
          body: <<~JSONLINES
            {"result":{"sender":"ASSISTANT","message":"The Impro","query":""}}
            {"result":{"sender":"ASSISTANT","message":"bability","query":""}}
            {"result":{"sender":"ASSISTANT","message":" Drive is","query":""}}
          JSONLINES
        )

      client = GrokApi::Client.new(logger: logger)
      client.start_conversation
      client.chat do
        say "Is the Improbability Drive incredible, or just highly improbable?"
        # VCR.use_cassette("conversation-1.chat1") do
          chat!
        # end
        say "From what book was that reference, again?"
        VCR.use_cassette("conversation-1.chat2") do
          chat!
        end
      end
    end
  end

  def stub_conversation_id
    stub_request(:get, "https://twitter.com/i/api/2/grok/conversation_id.json")
      .to_return(
        status: 200,
        headers: {
          "Set-Cookie" => "guest_id=v1%3A1234; Max-Age=63072000; Expires=Fri, 19 Dec 2025 22:10:41 GMT; Path=/; Domain=.twitter.com; Secure; SameSite=None",
          "Content-Type" => "application/json;charset=utf-8"
        },
        body: '{"conversationId":"1234"}'
      )
  end
end
