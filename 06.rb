# frozen_string_literal: true

require_relative 'utils'

DAY = '06'

def find_marker(chars, buffer_size)
  (buffer_size..chars.size).each do |index|
    return index if Set.new(chars[(index - buffer_size)...index]).size == buffer_size
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  puts "characters processed before the marker: #{find_marker(input.first.chars, 4)}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  puts "characters processed before the message: #{find_marker(input.first.chars, 14)}"
end

run_first(sample: false)
run_second(sample: false)
