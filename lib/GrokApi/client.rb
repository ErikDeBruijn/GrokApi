require "faraday"

module GrokApi
  class Client
    def initialize(cookie: nil, bearer_token: nil, csrf_token: nil, logger: false)
      @cookie = cookie || ENV['GROK_COOKIE']
      @token = bearer_token || ENV['GROK_BEARER_TOKEN']
      @csrf_token = csrf_token || ENV['GROK_CSRF_TOKEN']

      @connection = nil
      @logger = logger
      @conversationId = nil
      @conversation = Conversation.new
    end

    def start_conversation
      response = connection.get('/i/api/2/grok/conversation_id.json')
      raise "Invalid response: #{response.body}" unless response.body['conversationId']

      @conversationId = response.body['conversationId']
    end

    private

    def connection
      @connection ||= Faraday.new(url: 'https://twitter.com') do |faraday|
        faraday.headers['Host'] = 'twitter.com'
        faraday.headers['Cookie'] = @cookie
        faraday.headers['Accept'] = '*/*'
        faraday.headers['Accept-Language'] = 'en-US,en;q=0.9,nl;q=0.8'
        faraday.headers['Authorization'] = "Bearer #{@token}"
        faraday.headers['x-csrf-token'] = @csrf_token

        faraday.response :json
        faraday.response :logger if @logger
      end
    end
  end
end
