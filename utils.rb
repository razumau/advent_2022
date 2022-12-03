def input(day:)
  filename = "input/#{day}.txt"
  File.readlines(filename, chomp: true)
end

def sample_input(day:)
  filename = "sample/#{day}.txt"
  File.readlines(filename, chomp: true)
end
