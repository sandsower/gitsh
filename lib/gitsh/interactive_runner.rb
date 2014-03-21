require 'gitsh/completer'

module Gitsh
  class InteractiveRunner
    def initialize(history, readline, env)
      @history = history
      @readline = readline
      @env = env
    end

    def run_interactive
      history.load
      setup_readline
    #  greet_user
    #  interactive_loop
    #ensure
    #  history.save
    end

    private

    attr_reader :history, :readline, :env

    def setup_readline
      readline.completion_append_character = nil
      readline.completion_proc = Completer.new(readline, env)
    end
  end
end
