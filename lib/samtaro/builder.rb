# frozen_string_literal: true

require 'tmpdir'
require 'open3'

module Samtaro
  class Builder
    # @param [String] runtime
    def initialize(runtime:, directory:, logger:)
      @runtime = runtime
      @directory = directory
      @logger= logger

      validate_params!
    end

    def build
      case @runtime
      when 'nodejs6.10'
        Nodejs.new(@directory, @logger).build
      else
        raise "Unknown runtime: #{@runtime}"
      end
    end

    private

    def validate_params!
      if @runtime.nil?
        raise 'runtime should not be nil.'
      end

      if @directory.nil?
        raise 'directory should not be nil.'
      end
    end

    class Nodejs
      def initialize(directory, logger)
        @directory = directory
        @logger = logger
      end

      def build
        @logger.info('Begin to build with Node.js 6.10 environment...')

        Dir.mktmpdir do |tmpdir|
          FileUtils.cp_r(Dir.glob("#{@directory}/*"), tmpdir)
          FileUtils.cp_r(Dir.glob("#{File.dirname(__FILE__)}/../../docker/nodejs6.10/*"), tmpdir)

          Dir.chdir(tmpdir)

          Open3.popen3('docker-compose build && docker-compose run amazonlinux') do |i, o, e, w|
            o.each do |line|
              @logger.info(line.chomp)
            end

            e.each do |line|
              @logger.info(line.chomp)
            end
          end

          @logger.info(Dir.entries(tmpdir))
        end
      end
    end
  end
end
