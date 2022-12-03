# frozen_string_literal: true

require_relative 'utils'

DAY = '00'

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
end

run_first(sample: true)
run_second(sample: true)
