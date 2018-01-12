# frozen_string_literal: true

require 'samtaro'
require 'optparse'
require 'pathname'

module Samtaro
  class CLI
    SUB_COMMANDS = %w[
      build
    ].freeze

    def self.start(argv)
      new(argv).run
    end

    def initialize(argv)
      @argv = argv.dup
      @help = false
      parser.order!(@argv)
    end

    def run
      if @help || @argv.empty?
        puts parser.help
        SUB_COMMANDS.each do |subcommand|
          puts create_subcommand(subcommand).new.parser.help
        end
      else
        create_subcommand(@argv.shift).new.run(@argv)
      end
    end

    private

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = 'samtaro'
        opts.version = VERSION
        opts.on('-h', '--help', 'Show help') { @help = true }
      end
    end

    def create_subcommand(sub)
      if SUB_COMMANDS.include?(sub)
        CLI.const_get(sub.split('-').map(&:capitalize).join(''))
      else
        STDERR.puts("No such subcommand: #{sub}")
        exit 1
      end
    end

    class Build
      def run(argv)
        parse!(argv)

        if @verbose
          Samtaro.logger.level = Logger::DEBUG
        end

        builder= Builder.new(
          runtime: @runtime,
          directory: @directory,
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
          opts.on('-d', '--directory=DIRECTORY', 'Target directory') { |d| @directory = d }
          opts.on('-r', '--runtime=RUNTIME', 'Runtime') { |r| @runtime = r }
          opts.on('-v', '--verbose', 'Enable verbose mode') { @verbose = true }
        end
      end
    end
  end
end
