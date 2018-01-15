# frozen_string_literal: true

require 'optparse'

module Samtaro
  class CLI
    class Clean
      def run(argv)
        parse!(argv)

        if @verbose
          Samtaro.logger.level = Logger::DEBUG
        end

        cleaner = Cleaner.new(
          artifact_dir: @artifact_dir || Samtaro::DEFAULT_ARTIFACT_DIR,
          assume_yes: @assume_yes,
          logger: Samtaro.logger,
        )
        cleaner.clean
      end

      def parse!(argv)
        @verbose = false
        @assume_yes = false
        parser.parse!(argv)
      end

      def parser
        @parser ||= OptionParser.new do |opts|
          opts.banner = 'samtaro clean [OPTIONS]'
          opts.version = VERSION
          opts.on('-a', '--artifact-directory=DIRECTORY', 'Artifact directory') { |a| @artifact_dir = a }
          opts.on('-y', '--assumeyes', 'Do not confirm when delete a directory') { |y| @assume_yes = y }
          opts.on('-v', '--verbose', 'Enable verbose mode') { @verbose = true }
        end
      end
    end
  end
end
