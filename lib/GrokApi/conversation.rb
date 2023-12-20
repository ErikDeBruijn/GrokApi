module GrokApi
  class Conversation
    attr_reader :messages

    def initialize
      @messages = []
    end

    def <<(message)
      @messages << message
    end
  end
end
