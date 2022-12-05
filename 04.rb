# frozen_string_literal: true

require_relative 'utils'

DAY = '04'

Interval = Data.define(:start, :finish) do
  def fully_contains?(interval)
    start <= interval.start && interval.finish <= finish
  end

  def overlaps?(interval)
    (finish >= interval.start && finish <= interval.finish) || (interval.finish >= start && interval.finish <= finish)
  end
end

def build_intervals(input)
  input.map { |line| line.split(',') }.map do |first_interval, second_interval|
    [Interval.new(*first_interval.split('-').map(&:to_i)), Interval.new(*second_interval.split('-').map(&:to_i))]
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  pairs = build_intervals(input)
  one_fully_contains_another = pairs.filter { |first, second| first.fully_contains?(second) || second.fully_contains?(first) }
  puts "number of pairs where one interval fully contains another is #{one_fully_contains_another.size}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  pairs = build_intervals(input)
  has_overlap = pairs.filter { |first, second| first.overlaps?(second) }
  puts "number of pairs where one interval overlaps another is #{has_overlap.size}"
end

run_first(sample: false)
run_second(sample: false)
