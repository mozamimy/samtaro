require 'samtaro/cli'
require 'samtaro/builder'
require 'samtaro/version'

require 'logger'

module Samtaro
  def self.logger
    @logger ||=
      begin
        STDOUT.sync = true
        Logger.new(STDOUT).tap do |l|
          l.level = Logger::INFO
        end
      end
  end
end
