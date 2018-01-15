require 'samtaro/cli'
require 'samtaro/cli/build'
require 'samtaro/cli/clean'
require 'samtaro/builder'
require 'samtaro/cleaner'
require 'samtaro/version'

require 'logger'

module Samtaro
  DEFAULT_SRC_DIR = './src'
  DEFAULT_ARTIFACT_DIR = './build'
  DEFAULT_RUNTIME = 'nodejs6.10'

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
