module GrokApi
  class Conversation
    attr_reader :messages
    attr_accessor :topic

    def initialize(topic: nil)
      @messages = []
      @topic = nil
      @logger = Logger.new(STDOUT)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime}: #{msg}\n"
      end
    end

    def <<(message)
      if @messages.empty?
        # trim message to first line, max. 50 characters:
        @topic = message.split("\n").first[0..49]
        @logger.info("💬 ____________________________________________________________")
        @logger.info("💬 New conversation started on \"#{@topic}\"")
      end
      @logger.info("💬 You: #{message}")
      @messages << { "message" => message, "sender" => 1 }
    end

    def assistant_response(message)
      @logger.info("🤖 Grok: #{message}")
      @messages << { "message" => message, "sender" => 2 }
    end
  end
end
