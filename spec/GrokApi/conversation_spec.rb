describe GrokApi::Conversation do
  it "adds the message to the conversation" do
    conversation = GrokApi::Conversation.new

    conversation << "Is the Improbability Drive incredible, or just highly improbable?"

    expect(conversation.messages.first)
      .to eq({ "message" => "Is the Improbability Drive incredible, or just highly improbable?", "sender" => 1 })
  end
end
