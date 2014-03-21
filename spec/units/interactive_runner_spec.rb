require 'spec_helper'
require 'gitsh/interactive_runner'
describe Gitsh::InteractiveRunner do
  describe '#run_interactive' do
    it 'loads the history' do
      history = stub('History', load: nil)
      readline = stub('Readline', :completion_append_character= => nil, :completion_proc= => nil)
      env = stub('Environment')

      runner = Gitsh::InteractiveRunner.new(history, readline, env)
      runner.run_interactive

      expect(history).to have_received(:load)
    end

    it 'setsup readline' do
      history = stub('History', load: nil)
      readline = stub('Readline', :completion_append_character= => nil, :completion_proc= => nil)
      env = stub('Environment')

      runner = Gitsh::InteractiveRunner.new(history, readline, env)
      runner.run_interactive

      expect(readline).to have_received(:completion_append_character=)
      expect(readline).to have_received(:completion_proc=)
    end
  end
end
