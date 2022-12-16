# frozen_string_literal: true

require_relative 'utils'

DAY = '11'

Item = Struct.new("Item", :worry, :owner) do
  def inspect
    worry.to_s
  end
end

class Game
  def initialize(input, boredom_relief=true, rounds=20)
    @monkeys = {}
    @number_of_rounds = rounds
    current_monkey_lines = []
    current_monkey_number = 0

    input.each do |line|
      if line == ""
        @monkeys[current_monkey_number] = Monkey.new(current_monkey_lines)
        current_monkey_number += 1
        current_monkey_lines = []
      else
        current_monkey_lines << line
      end
    end
    @modulo = @monkeys.values.map(&:test_number).reduce(:*)
  end

  def run
    @number_of_rounds.times do |round|
      if round % 10 == 0
        scale_down
      end
      @monkeys.each do |number, monkey|
        monkey.make_turn
        monkey.items.each do |item|
          @monkeys[item.owner].items << item
        end
        monkey.items = []
      end
    end
  end

  def scale_down
    @monkeys.values.each do |monkey|
      monkey.items.each { |item| item.worry = item.worry % @modulo }
    end
  end

  def monkey_business
    most_active = @monkeys.values.map(&:inspections).max(2)
    most_active.first * most_active.last
  end
end

class Monkey
  attr_reader :new_owners, :inspections, :test_number
  attr_accessor :items

  def initialize(input, boredom_relief=false)
    @number = input[0][-2].to_i
    @items = input[1].split(":").last.split.map(&:to_i).map { |item| Item.new(worry: item, owner: @number) }
    @operation = input[2].split(" = ").last
    @test_number = input[3].split.last.to_i
    @throw_to = {
      true => input[4].split.last.to_i,
      false => input[5].split.last.to_i
    }
    @new_owners = []
    @inspections = 0
    @boredom_relief = boredom_relief
  end

  def make_turn
    @new_owners = []
    @items.each do |item|
      item.worry = inspect_item(item.worry)
      item.worry = get_bored(item.worry) if @boredom_relief
      item.owner = new_owner(item.worry)
    end
  end

  def inspect_item(old)
    @inspections += 1
    eval @operation
  end

  def get_bored(item)
    item / 3
  end

  def new_owner(item)
    @throw_to[item % @test_number == 0]
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  game = Game.new(input)
  game.run
  puts "monkey business after 20 rounds: #{game.monkey_business}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  game = Game.new(input, false, 10000)
  game.run
  puts "monkey business after 10000 rounds: #{game.monkey_business}"
end

run_first(sample: false)
run_second(sample: false)
