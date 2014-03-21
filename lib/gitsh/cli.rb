require 'readline'
require 'optparse'
require 'gitsh/environment'
require 'gitsh/interactive_runner'
require 'gitsh/program_name'
require 'gitsh/readline_blank_filter'
require 'gitsh/version'

module Gitsh
  class CLI
    EX_OK = 0
    EX_USAGE = 64

    def initialize(opts={})
      $PROGRAM_NAME = PROGRAM_NAME

      @env = opts.fetch(:env, Environment.new)
      @readline = ReadlineBlankFilter.new(opts.fetch(:readline, Readline))
      @unparsed_args = opts.fetch(:args, ARGV).clone
      @interactive_runner = opts.fetch(:interactive_runner, InteractiveRunner.new(
        readline: @readline,
        env: @env
      ))
    end

    def run
      parse_arguments
      if unparsed_args.any?
        exit_with_usage_message
      else
        interactive_runner.run_interactive
      end
    end

    private

    attr_reader :env, :unparsed_args, :interactive_runner

    def exit_with_usage_message
      env.puts_error option_parser.banner
      exit EX_USAGE
    end

    def parse_arguments
      option_parser.parse!(unparsed_args)
    rescue OptionParser::InvalidOption => err
      unparsed_args.concat(err.args)
    end

    def option_parser
      OptionParser.new do |opts|
        opts.banner = 'usage: gitsh [--version] [-h | --help] [--git PATH]'

        opts.on('--git [COMMAND]', 'Use the specified git command') do |git_command|
          env.git_command = git_command
        end

        opts.on_tail('--version', 'Display the version and exit') do
          env.puts VERSION
          exit EX_OK
        end

        opts.on_tail('--help', '-h', 'Display this help message and exit') do
          env.puts opts
          exit EX_OK
        end
      end
    end
  end
end
