# frozen_string_literal: true

require_relative 'utils'

DAY = '03'

def priority(item)
  if item.downcase == item
    item.ord - 96
  else
    item.ord - 38
  end
end

def halves(line)
  half_length = line.size / 2
  [line[0...half_length], line[half_length..-1]]
end

def common_char(*lines)
  sets = lines.map { |line| Set.new(line.chars) }
  intersection = sets.first
  sets[1..-1].each do |set|
    intersection = intersection.intersection(set)
  end
  intersection.first
end

def common_item(first_half, second_half)
  common_char(first_half, second_half)
end

def badge_for_group(first_rucksack, second_rucksack, third_rucksack)
  common_char(first_rucksack, second_rucksack, third_rucksack)
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  common_items = input.map { |line| common_item(*halves(line)) }
  priorities_sum = common_items.map { |item| priority(item) }.sum
  p "sum of priorities is #{priorities_sum}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  badges = input.each_slice(3).map { |first, second, third| badge_for_group(first, second, third) }
  priorities_sum = badges.map { |item| priority(item) }.sum
  p "sum of badges’ priorities is #{priorities_sum}"
end

run_first(sample: false)
run_second(sample: false)
