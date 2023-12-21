# frozen_string_literal: true

require_relative "../lib/GrokAPI"
require_relative "../lib/GrokAPI/client"
require_relative "../lib/GrokAPI/conversation"

require "rspec"
require "vcr"
require "webmock/rspec"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr"
  c.hook_into :webmock
end
