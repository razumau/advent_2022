# frozen_string_literal: true

require_relative 'utils'

DAY = '15'

Sensor = Struct.new(:x, :y, :beacon, :distance) do
  def within_distance?(other_x, other_y)
    (x - other_x).abs + (y - other_y).abs <= distance
  end
end

Beacon = Struct.new(:x, :y)

def build_sensors(input)
  input.map do |line|
    sensor_str, beacon_str = line.split(': closest beacon is at ')
    beacon = Beacon.new(x: beacon_str.match(/x=(-?\d+), y=(-?\d+)/)[1].to_i,
                        y: beacon_str.match(/x=(-?\d+), y=(-?\d+)/)[2].to_i)
    Sensor.new(x: sensor_str.match(/x=(-?\d+), y=(-?\d+)/)[1].to_i,
               y: sensor_str.match(/x=(-?\d+), y=(-?\d+)/)[2].to_i,
               beacon:)
  end
end

def find_extreme_points(sensors)
  left, right = 0, 0
  sensors.each do |sensor|
    left = [sensor.x - sensor.distance, left].min
    right = [sensor.x + sensor.distance, right].max
  end
  [left, right]
end

def covered_by_any?(sensors, x, y)
  sensors.each do |sensor|
    return true if sensor.within_distance?(x, y)
  end
  false
end

def count_covered_points(sensors:, target_row:, start:, finish:)
  (start..finish).count do |x|
    covered_by_any?(sensors, x, target_row)
  end
end

def count_beacons_in_row(sensors, row)
  Set.new(sensors.filter_map { |sensor| sensor.beacon if sensor.beacon.y == row }).size
end

def find_sensor(sensors, x, y)
  sensors.each do |sensor|
    return sensor if sensor.within_distance?(x, y)
  end
  nil
end

def find_beacon(sensors, floor, ceiling)
  x = floor
  y = floor
  loop do
    sensor = find_sensor(sensors, x, y)

    return [x, y] if sensor.nil?

    rightmost_sensor_x = (sensor.distance - (sensor.y - y).abs) + sensor.x
    x = rightmost_sensor_x

    if x >= ceiling
      y += 1
      x = floor
    else
      x += 1
    end
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  target_row = sample ? 10 : 2000000

  sensors = build_sensors(input)
  sensors.each do |sensor|
    sensor.distance = (sensor.x - sensor.beacon.x).abs + (sensor.y - sensor.beacon.y).abs
  end
  start, finish = find_extreme_points(sensors)
  points = count_covered_points(sensors:, target_row:, start:, finish:)
  beacons_in_row = count_beacons_in_row(sensors, target_row)
  puts "points: #{points}"
  puts "beacons in that row: #{beacons_in_row}"
  puts "result: #{points - beacons_in_row}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  floor = 0
  ceiling = sample ? 20 : 4000000
  sensors = build_sensors(input)
  sensors.each do |sensor|
    sensor.distance = (sensor.x - sensor.beacon.x).abs + (sensor.y - sensor.beacon.y).abs
  end
  x, y = find_beacon(sensors, floor, ceiling)
  p [x, y]
  puts "tuning frequency is #{x * 4000000 + y}"
end

run_first(sample: false)
run_second(sample: false)
