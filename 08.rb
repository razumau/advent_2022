# frozen_string_literal: true

require_relative 'utils'

DAY = '08'

class Map
  def initialize(input)
    @map = input.map { |line| line.chars.map(&:to_i) }
    @map.each { |line| p line}
  end

  def visible?(row, column)
    visible_from_top?(row, column) ||
      visible_from_bottom?(row, column) ||
      visible_from_left?(row, column) ||
      visible_from_right?(row, column)
  end

  def visible_from_top?(row, column)
    trees_above = (0...row).map { |i| @map[i][column] }
    (row == 0) || trees_above.all? { |tree| tree < @map[row][column] }
  end

  def visible_from_bottom?(row, column)
    trees_below = ((row + 1)...@map.size).map { |i| @map[i][column] }
    (row == @map.size) || trees_below.all? { |tree| tree < @map[row][column] }
  end

  def visible_from_left?(row, column)
    trees_to_the_left = (0...column).map { |i| @map[row][i] }
    (column == 0) || trees_to_the_left.all? { |tree| tree < @map[row][column] }
  end

  def visible_from_right?(row, column)
    trees_to_the_right = ((column + 1)...@map.size).map { |i| @map[row][i] }
    (column == @map.size) || trees_to_the_right.all? { |tree| tree < @map[row][column] }
  end

  def visible_count
    (0...@map.size).map do |row|
      (0...@map.size).count do |column|
        visible?(row, column)
      end
    end.sum
  end

  def score(row, column)
    top_score(row, column) * bottom_score(row, column) * left_score(row, column) * right_score(row, column)
  end

  def top_score(row, column)
    seen_trees = 0
    house_tree = @map[row][column]
    (0...row).reverse_each do |i|
      seen_trees += 1
      return seen_trees if @map[i][column] >= house_tree
    end
    seen_trees
  end

  def bottom_score(row, column)
    seen_trees = 0
    house_tree = @map[row][column]
    ((row + 1)...@map.size).each do |i|
      seen_trees += 1
      return seen_trees if @map[i][column] >= house_tree
    end
    seen_trees
  end

  def left_score(row, column)
    seen_trees = 0
    house_tree = @map[row][column]
    (0...column).reverse_each do |i|
      seen_trees += 1
      return seen_trees if @map[row][i] >= house_tree
    end
    seen_trees
  end

  def right_score(row, column)
    seen_trees = 0
    house_tree = @map[row][column]
    ((column + 1)...@map.size).each do |i|
      seen_trees += 1
      return seen_trees if @map[row][i] >= house_tree
    end
    seen_trees
  end

  def max_score
    (0...@map.size).map do |row|
      (0...@map.size).map do |column|
        score(row, column)
      end.max
    end.max
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  map = Map.new(input)
  p map.visible_count
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  map = Map.new(input)
  p map.max_score
end

run_first(sample: false)
run_second(sample: false)
