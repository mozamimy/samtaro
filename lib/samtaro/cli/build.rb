# frozen_string_literal: true

require 'optparse'

module Samtaro
  class CLI
    class Build
      def run(argv)
        parse!(argv)

        if @verbose
          Samtaro.logger.level = Logger::DEBUG
        end

        builder = Builder.new(
          source_dir: @source_dir || Samtaro::DEFAULT_SRC_DIR,
          artifact_dir: @artifact_dir || Samtaro::DEFAULT_ARTIFACT_DIR,
          runtime: @runtime || Samtaro::DEFAULT_RUNTIME,
          logger: Samtaro.logger,
        )
        builder.build
      end

      def parse!(argv)
        @verbose = false
        parser.parse!(argv)
      end

      def parser
        @parser ||= OptionParser.new do |opts|
          opts.banner = 'samtaro build [OPTIONS]'
          opts.version = VERSION
          opts.on('-a', '--artifact-directory=DIRECTORY', 'Artifact directory') { |a| @artifact_dir = a }
          opts.on('-r', '--runtime=RUNTIME', 'Runtime') { |r| @runtime = r }
          opts.on('-s', '--source-directory=DIRECTORY', 'Source directory') { |s| @source_dir = d }
          opts.on('-v', '--verbose', 'Enable verbose mode') { @verbose = true }
        end
      end
    end
  end
end
