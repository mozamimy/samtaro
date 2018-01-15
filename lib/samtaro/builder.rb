# frozen_string_literal: true

require 'open3'
require 'fileutils'

module Samtaro
  class Builder
    # @param [String] runtime
    def initialize(source_dir:, artifact_dir:, runtime:, logger:)
      @source_dir = source_dir
      @artifact_dir = artifact_dir
      @runtime = runtime
      @logger= logger

      validate_params!
    end

    def build
      case @runtime
      when 'nodejs6.10'
        Nodejs.new(
          source_dir: @source_dir,
          artifact_dir: @artifact_dir,
          logger: @logger,
        ).build
      else
        raise "Unknown runtime: #{@runtime}"
      end
    end

    private

    def validate_params!
      raise 'artifact_dir should not be nil.' if @artifact_dir.nil?
      raise 'source_dir should not be nil.' if @source_dir.nil?
      raise 'runtime should not be nil.' if @runtime.nil?
    end

    class Nodejs
      def initialize(source_dir:, artifact_dir:, logger:)
        @source_dir = source_dir
        @artifact_dir = artifact_dir
        @logger = logger
      end

      def build
        @logger.info('Begin to build with Node.js 6.10 environment...')

        if Dir.exist?(@artifact_dir)
          FileUtils.rm_r(@artifact_dir)
          @logger.debug("#{@artifact_dir} is deleted.")
        end

        FileUtils.mkdir(@artifact_dir)
        @logger.debug("#{@artifact_dir} is created.")

        FileUtils.cp_r(Dir.glob("#{@source_dir}/*"), @artifact_dir)
        FileUtils.cp_r(Dir.glob("#{File.dirname(__FILE__)}/../../docker/nodejs6.10/*"), @artifact_dir)
        @logger.debug('Files for build are copied.')

        Dir.chdir(@artifact_dir)

        Open3.popen3('docker-compose build && docker-compose run amazonlinux') do |i, o, e, w|
          o.each do |line|
            @logger.info(line.chomp)
          end

          e.each do |line|
            @logger.info(line.chomp)
          end
        end

        @logger.info('Done.')
      end
    end
  end
end
