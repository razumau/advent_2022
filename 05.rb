# frozen_string_literal: true

require_relative 'utils'

DAY = '05'

Move = Data.define(:from, :to, :how_many)

class CrateMover
  def initialize(stacks, moves)
    @stacks = stacks
    @stacks.prepend([])
    @moves = moves
  end

  def run!
    @moves.each do |move|
      make_move(move)
    end
  end

  def tops
    @stacks.map(&:first).compact.join
  end
end

class CrateMover9000 < CrateMover
  def make_move(move)
    moving = @stacks[move.from].shift(move.how_many).reverse
    @stacks[move.to].prepend(*moving)
  end
end

class CrateMover9001 < CrateMover
  def make_move(move)
    moving = @stacks[move.from].shift(move.how_many)
    @stacks[move.to].prepend(*moving)
  end
end

def split_lines_by_category(input)
  stack_lines = []
  move_lines = []
  numbers_line = ''
  input.each do |line|
    if line.include?('[')
      stack_lines << line
    elsif line.start_with?('move')
      move_lines << line
    elsif line.start_with?(' 1')
      numbers_line = line
    end
  end
  [stack_lines, move_lines, numbers_line]
end

def collect_stacks(stack_lines, stacks_number)
  stack_lines.map { |line| line.ljust(stacks_number * 4) }
             .map(&:chars)
             .transpose
             .filter { |list| list.any?(/[A-Z]/) }
             .map { |list| list.reject { |item| item == ' ' } }
end

def collect_moves(move_lines)
  move_lines.map do |line|
    split = line.split
    Move.new(how_many: split[1].to_i, from: split[3].to_i, to: split[5].to_i)
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  stack_lines, move_lines, numbers_line = split_lines_by_category(input)
  stacks_number = numbers_line[-1].to_i
  stacks = collect_stacks(stack_lines, stacks_number)
  moves = collect_moves(move_lines)
  runner = CrateMover9000.new(stacks, moves)
  runner.run!
  puts "top elements for CrateMover9000 are #{runner.tops}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  stack_lines, move_lines, numbers_line = split_lines_by_category(input)
  stacks_number = numbers_line[-1].to_i
  stacks = collect_stacks(stack_lines, stacks_number)
  moves = collect_moves(move_lines)
  runner = CrateMover9001.new(stacks, moves)
  runner.run!
  puts "top elements for CrateMover9001 are #{runner.tops}"
end

run_first(sample: false)
run_second(sample: false)
