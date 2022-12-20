# frozen_string_literal: true

require_relative 'utils'

DAY = '13'

def compare(left, right)
  case [left, right]
  in Integer => left_number, Integer => right_number
    return 1 if left_number < right_number
    return -1 if left_number > right_number

    0
  in Array => left_list, Array => right_list
    (0...[left_list.size, right_list.size].min).each do |index|
      result = compare(left_list[index], right_list[index])
      unless result == 0
        return result
      end
    end

    return 1 if left_list.size < right_list.size
    return -1 if left_list.size > right_list.size

    0
  in Array => left_list, Integer => right_number
    compare(left_list, [right_number])
  in Integer => left_number, Array => right_list
    compare([left_number], right_list)
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)

  right_order_sum = input.each_slice(3).each_with_index.map do |block, index|
    left, right, _ =  block
    index + 1 if compare(eval(left), eval(right)) == 1
  end.compact.sum
  puts "sum of indices of right-ordered pairs: #{right_order_sum}"
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  dividers = [[[2]], [[6]]]
  packets = input.filter_map { |line| eval(line) unless line == '\n' } + dividers
  sorted = packets.sort { |first, second| -compare(first, second) }
  decoder_key = (sorted.find_index(dividers.first) + 1) * (sorted.find_index(dividers.last) + 1)
  puts "decoder key is #{decoder_key}"
end

run_first(sample: false)
run_second(sample: false)
