# frozen_string_literal: true

require 'fileutils'

module Samtaro
  class Cleaner
    def initialize(artifact_dir:, assume_yes:, logger:)
      @artifact_dir = artifact_dir
      @assume_yes = assume_yes
      @logger = logger
    end

    def clean
      @logger.info('Begin to clean artifact directory...')

      unless @assume_yes
        print "Are you sure to delete #{@artifact_dir}? [y/n] > "
        prompt = STDIN.gets.chomp

        unless %w[y Y].include?(prompt)
          @logger.info('Aborted.')
          exit 1
        end
      end

      if Dir.exist?(@artifact_dir)
        FileUtils.rm_r(@artifact_dir)
      else
        @logger.error("#{@artifact_dir} is not found.")
        exit 1
      end

      @logger.info('Done.')
    end
  end
end
