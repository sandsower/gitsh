require 'gitsh/completer'
require 'gitsh/interpreter'

module Gitsh
  class InteractiveRunner
    def initialize(opts)
      @history = opts[:history]
      @readline = opts[:readline]
      @env = opts[:env]
      @interpreter = opts[:interpreter]
    end

    def run_interactive
      history.load
      setup_readline
      greet_user
      interactive_loop
    ensure
      history.save
    end

    private

    attr_reader :history, :readline, :env, :interpreter

    def setup_readline
      readline.completion_append_character = nil
      readline.completion_proc = Completer.new(readline, env)
    end

    def greet_user
      unless env['gitsh.noGreeting'] == 'true'
        env.puts "gitsh #{Gitsh::VERSION}\nType :exit to exit"
      end
    end
    
    def interactive_loop
      while command = read_command
        interpreter.execute(command)
      end
      env.print "\n"
    rescue Interrupt
      env.print "\n"
      retry
    end

    def read_command
      command = readline.readline(prompt, true)
      if command && command.empty?
        env.fetch('gitsh.defaultCommand', 'status')
      else
        command
      end
    end

    def prompt
      prompter.prompt
    end

    def prompter
      @prompter ||= Prompter.new(env: env, color: color_support?)
    end

    def color_support?
      output, error, exit_status = Open3.capture3('tput colors')
      exit_status.success? && output.chomp.to_i > 0
    end
  end
end
