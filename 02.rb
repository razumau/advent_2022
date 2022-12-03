# frozen_string_literal: true

require_relative 'utils'

DAY = '02'

def score_game(game_line)
  outcomes = {
    AX: 4,
    AY: 8,
    AZ: 3,
    BX: 1,
    BY: 5,
    BZ: 9,
    CX: 7,
    CY: 2,
    CZ: 6
  }

  outcomes[game_line.gsub(' ', '').to_sym]
end

def pick_response(game_line)
  responses = {
    AX: 'Z',
    AY: 'X',
    AZ: 'Y',
    BX: 'X',
    BY: 'Y',
    BZ: 'Z',
    CX: 'Y',
    CY: 'Z',
    CZ: 'X'
  }

  response = responses[game_line.gsub(' ', '').to_sym]
  "#{game_line.split.first}#{response}"
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  score = input.map { |line| score_game(line) }.sum
  puts "total score is #{score}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  games = input.map do |line|
    pick_response(line)
  end
  score = games.map { |line| score_game(line) }.sum
  puts "total score is #{score}"
end

run_first(sample: false)
run_second(sample: false)
