# frozen_string_literal: true

require_relative 'utils'

DAY = '09'

class Rope
  attr_reader :tail

  def initialize
    @head = [1, 1]
    @tail = [1, 1]
    @visited = Set.new
    @visited << @tail.to_s
  end

  def run_command(command)
    direction, steps = command.split
    steps.to_i.times do
      step(direction)
    end
  end

  def step(where)
    case where
    when 'R'
      @head[0] += 1
    when 'L'
      @head[0] -= 1
    when 'U'
      @head[1] += 1
    when 'D'
      @head[1] -= 1
    else
      raise StandardError
    end

    update_tail_position
  end

  def update_tail_position
    return if head_and_tail_touch?

    move_tail_to_head
    @visited << @tail.to_s
  end

  def move_tail_to_head
    @tail[0] += 1 if @head[0] > @tail[0]
    @tail[0] -= 1 if @tail[0] > @head[0]
    @tail[1] += 1 if @head[1] > @tail[1]
    @tail[1] -= 1 if @tail[1] > @head[1]
  end

  def head_and_tail_touch?
    (@head[0] - @tail[0]).abs <= 1 && (@head[1] - @tail[1]).abs <= 1
  end

  def visited_count
    @visited.size
  end

  def move_head_to(x, y)
    @head[0] = x
    @head[1] = y

    update_tail_position
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  rope = Rope.new
  input.each { |line| rope.run_command(line) }
  puts "tail has visited #{rope.visited_count} positions"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  ropes = Array.new(9) { Rope.new }
  input.each do |line|
    direction, steps = line.split
    steps.to_i.times do
      ropes.first.step(direction)
      ropes.each_cons(2) do |head, tail|
        tail.move_head_to(*head.tail)
      end
    end
  end
  puts "tail has visited #{ropes.last.visited_count} positions"
end

run_first(sample: false)
run_second(sample: false)
