# frozen_string_literal: true

require_relative 'utils'

DAY = '14'

Point = Struct.new(:x, :y, :state)

class Map
  def initialize(input)
    depth = max_y(input)
    @left, right = x_extremes(input)
    @map = Array.new(depth + 1) do |y|
      Array.new(right - @left + 1) do |x|
        Point.new(x:, y:, state: '.')
      end
    end

    input.each do |line|
      points = line.split(' -> ')
      points.each_cons(2) do |a, b|
        a_x, a_y = a.split(',').map(&:to_i)
        b_x, b_y = b.split(',').map(&:to_i)

        if a_x == b_x
          ([a_y, b_y].min..[a_y, b_y].max).each { |y| @map[y][a_x - @left].state = '#' }
        elsif a_y == b_y
          ([a_x, b_x].min..[a_x, b_x].max).each { |x| @map[a_y][x - @left].state = '#' }
        end
      end
    end

    draw
  end

  def draw
    @map.each do |line|
      puts line.map(&:state).join
    end
  end

  def max_y(input)
    current_max = 0
    input.each do |line|
      points = line.split(' -> ')
      points.each do |point|
        y = point.split(',').last.to_i
        current_max = [y, current_max].max
      end
    end
    current_max
  end

  def x_extremes(input)
    current_min, current_max = 500, 0
    input.each do |line|
      points = line.split(' -> ')
      points.each do |point|
        y = point.split(',').first.to_i
        current_max = [y, current_max].max
        current_min = [y, current_min].min
      end
    end
    [current_min, current_max]
  end

  def pour_sand
    count = 0
    loop do
      count += 1
      x, y = find_next_sand_position
      return count if y >= @map.size - 1 || x < 0 || x >= @map.first.size - 1

      @map[y][x].state = 'o'
    end
  end

  def find_next_sand_position
    x, y = 500 - @left, 0
    loop do
      return [x, y] if y >= @map.size - 1 || x < 0 || x >= @map.first.size - 1

      if @map[y + 1][x].state == '.'
        y += 1
        next
      end

      if @map[y + 1][x - 1].state == '.'
        y += 1
        x -= 1
        next
      end

      if @map[y + 1][x + 1].state == '.'
        y += 1
        x += 1
        next
      end

      return [x, y]
    end
  end
end

class Map_b < Map
  def initialize(input)
    depth = max_y(input) + 2
    input.append("-1000,#{depth} -> 1000,#{depth}")

    @left, right = x_extremes(input)
    @map = Array.new(depth + 1) do |y|
      Array.new(right - @left + 1) do |x|
        Point.new(x:, y:, state: '.')
      end
    end

    input.each do |line|
      points = line.split(' -> ')
      points.each_cons(2) do |a, b|
        a_x, a_y = a.split(',').map(&:to_i)
        b_x, b_y = b.split(',').map(&:to_i)

        if a_x == b_x
          ([a_y, b_y].min..[a_y, b_y].max).each { |y| @map[y][a_x - @left].state = '#' }
        elsif a_y == b_y
          ([a_x, b_x].min..[a_x, b_x].max).each { |x| @map[a_y][x - @left].state = '#' }
        end
      end
    end

    draw
  end

  def pour_sand
    count = 0
    loop do
      count += 1
      x, y = find_next_sand_position
      return count if y == 0 && x + @left == 500

      @map[y][x].state = 'o'
    end
  end

  def find_next_sand_position
    x, y = 500 - @left, 0
    loop do
      if @map[y + 1][x].state == '.'
        y += 1
        next
      end

      if @map[y + 1][x - 1].state == '.'
        y += 1
        x -= 1
        next
      end

      if @map[y + 1][x + 1].state == '.'
        y += 1
        x += 1
        next
      end

      return [x, y]
    end
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  map = Map.new(input)
  p map.pour_sand - 1
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  map = Map_b.new(input)
  p map.pour_sand
end

# run_first(sample: false)
run_second(sample: false)
