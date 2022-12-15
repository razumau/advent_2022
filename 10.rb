# frozen_string_literal: true

require_relative 'utils'

DAY = '10'

class CPU
  attr_reader :history

  def initialize(commands)
    @commands = commands
    @cycle_count = 0
    @register = 1
    @waiting_to_add = nil
    @history = []
  end

  def next_cycle!
    @history << @register
    @cycle_count += 1
    unless @waiting_to_add.nil?
      @register += @waiting_to_add
      @waiting_to_add = nil
      return
    end

    command = @commands.shift
    return if command == 'noop'

    @waiting_to_add = command.split.last.to_i
  end

  def run
    until @commands.empty? && @waiting_to_add.nil?
      next_cycle!
    end
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  cpu = CPU.new(input)
  cpu.run
  strength = (20..cpu.history.size).step(40).reduce(0) { |sum, i| sum + i * cpu.history[i - 1] }
  puts "signal strength is #{strength}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
end

run_first(sample: false)
run_second(sample: true)
