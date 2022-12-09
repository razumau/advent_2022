# frozen_string_literal: true

require_relative 'utils'

DAY = '07'

class FileSystem
  def initialize
    @current_dir = nil
    @directories = Hash.new(0)
  end

  ROOT = '/'

  attr_reader :directories

  def run_command(command)
    return if command == '$ ls'

    target_directory = command.split.last
    @current_dir = build_path(target_directory)
  end

  def build_path(target_directory)
    return ROOT if target_directory == ROOT
    return parent(@current_dir) if target_directory == '..'

    if @current_dir == '/'
      "/#{target_directory}"
    else
      "#{@current_dir}/#{target_directory}"
    end
  end

  def parent(directory)
    maybe_parent = directory[0...directory.rindex('/')]
    return ROOT if maybe_parent == '' && directory != ROOT

    maybe_parent
  end

  def read_ls_line(line)
    size, = line.split
    return if size == 'dir'

    add_file_size_to_all_parents(size)
  end

  def add_file_size_to_all_parents(size)
    dir = @current_dir
    while dir != ''
      @directories[dir] += Integer(size)
      dir = parent(dir)
    end
  end
end

def run_first(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  fs = FileSystem.new
  input.each do |line|
    if line.start_with?("$")
      fs.run_command(line)
    else
      fs.read_ls_line(line)
    end
  end
  puts fs.directories.filter_map { |_, size| size if size <= 100_000 }.sum
end

def run_second(sample:)
  input = sample ? sample_input(day: DAY) : input(day: DAY)
  fs = FileSystem.new
  input.each do |line|
    if line.start_with?("$")
      fs.run_command(line)
    else
      fs.read_ls_line(line)
    end
  end
  unused = 70_000_000 - fs.directories[FileSystem::ROOT]
  to_be_removed = 30_000_000 - unused
  possible_deletions = fs.directories.filter_map { |_, size| size if size >= to_be_removed }
  puts possible_deletions.sort.first
end


run_first(sample: false)
run_second(sample: false)
