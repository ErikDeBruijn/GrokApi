# frozen_string_literal: true

require "faraday"

module GrokApi
  class Client
    def initialize(fun_mode: true, cookie: nil, bearer_token: nil, csrf_token: nil, logger: nil)
      @cookie = cookie || ENV["GROK_COOKIE"]
      @token = bearer_token || ENV["GROK_BEARER_TOKEN"]
      @csrf_token = csrf_token || ENV["GROK_CSRF_TOKEN"]
      @logger = logger || Logger.new($stderr)
      @logger.level = Logger::ERROR

      @connection = nil
      @conversationId = nil
      @fun_mode = fun_mode
      @conversation = Conversation.new
    end

    def start_conversation
      response = connection.get("/i/api/2/grok/conversation_id.json")
      raise "Invalid response: #{response.body}" unless response.body["conversationId"]

      @conversationId = response.body["conversationId"]
      @conversation
    end

    def chat(&block)
      raise "No conversation started" unless @conversationId

      instance_eval(&block)
    end

    def say(message)
      @conversation << message
    end

    def chat!
      puts "Going to send request... ConversationId: #{@conversationId}"
      send_messages
    end

    private

    def send_messages
      body = {
        "responses" => @conversation.messages.map { |message| { "message" => message, "sender" => 1 } },
        "systemPromptName" => @fun_mode ? "fun" : "",
        "conversationId" => @conversationId
      }.to_json

      response = Faraday.post("https://api.twitter.com/2/grok/add_response.json", body, api_headers)

      if response.success?
        # Parse the response body (which is in JSON Lines)
        responses = response.body.split("\n").map(&JSON.method(:parse))
        assistant_responses = responses.map do |line|
          line.dig("result", "message")
        end
        @conversation.assistant_response(assistant_responses.join(""))
      else
        # Handle the error
        @logger.error("Error: #{response.status}")
      end
    end

    def api_headers
      {
        "sec-ch-ua" => '"Not_A Brand";v="8", "Chromium";v="120"',
        "dnt" => "1",
        "x-twitter-client-language" => "en",
        "x-csrf-token" => @csrf_token,
        "sec-ch-ua-mobile" => "?0",
        "authorization" => "Bearer #{@token}",
        "user-agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "content-type" => "text/plain;charset=UTF-8",
        "referer" => "https://twitter.com/",
        "cookie" => @cookie
      }
    end

    def connection
      @connection ||= Faraday.new(url: "https://twitter.com") do |faraday|
        faraday.headers["Host"] = "twitter.com"
        faraday.headers["Cookie"] = @cookie
        faraday.headers["Accept"] = "*/*"
        faraday.headers["Accept-Language"] = "en-US,en;q=0.9,nl;q=0.8"
        faraday.headers["Authorization"] = "Bearer #{@token}"
        faraday.headers["x-csrf-token"] = @csrf_token

        faraday.response :json
        faraday.response :logger if @logger
      end
    end
  end
end
