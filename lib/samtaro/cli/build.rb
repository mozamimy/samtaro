# frozen_string_literal: true

module Samtaro
  class CLI
    class Build
      def run(argv)
        parse!(argv)

        if @verbose
          Samtaro.logger.level = Logger::DEBUG
        end

        builder = Builder.new(
          source_dir: @source_dir || './src',
          artifact_dir: @artifact_dir || './build',
          runtime: @runtime || 'nodejs6.10',
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
