# frozen_string_literal: true

require_relative 'utils'

DAY = '01'

Elf = Data.define(:calories)

def group_by_elf(input)
  elves = []
  current_elf = 0
  input.each do |calories_line|
    if calories_line == ''
      elves << Elf.new(current_elf)
      current_elf = 0
    else
      current_elf += calories_line.to_i
    end
  end
  elves
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  elves = group_by_elf(input)
  max_calories = elves.map(&:calories).max
  p "max calories carried by an elf is #{max_calories}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  elves = group_by_elf(input)
  carried_by_top_3_elves = elves.map(&:calories).sort[-3..-1].sum
  p "top three elves are carrying #{carried_by_top_3_elves} calories"
end

run_first(sample: false)
run_second(sample: false)
