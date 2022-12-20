#!/usr/bin/env ruby

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

FIRST = [
  %w[. . @ @ @ @ .]
]
SECOND = [
  %w[. . . @ . . .],
  %w[. . @ @ @ . .],
  %w[. . . @ . . .]
]
THIRD = [
  %w[. . . . @ . .],
  %w[. . . . @ . .],
  %w[. . @ @ @ . .]
]
FOURTH = [
  %w[. . @ . . . .],
  %w[. . @ . . . .],
  %w[. . @ . . . .],
  %w[. . @ . . . .]
]
FIFTH = [
  %w[. . @ @ . . .],
  %w[. . @ @ . . .]
]

filename = File.join(File.dirname(__FILE__), "input.txt")
directions = File.read(filename).split("\n").first.split("")

ROCKS = [FIRST, SECOND, THIRD, FOURTH, FIFTH]

rocks_idx = 0
rocks_size = ROCKS.size

directions_idx = 0
directions_size = directions.size

EMPTY = %w[. . . . . . .]
CHAMBER = [
  %w[# # # # # # #]
]

def print_chamber
  CHAMBER.each do |line|
    p line.join(" ")
  end
end

def move_dir(dir)
  direction = if dir == ">"
                1
              elsif dir == "<"
                -1
              else
                raise "Impossible #{dir}"
              end

  CHAMBER.each do |line|
    next unless line.include?("@")

    line.each_index do |idx|
      next unless line[idx] == "@"
      new_idx = idx + direction
      if new_idx < 0 || new_idx >= line.size || line[new_idx] == "#"
        return false
      end
    end
  end

  CHAMBER.each do |line|
    next unless line.include?("@")

    original = line.dup

    line.each_index do |idx|
      new_idx = idx + direction
      if original[idx] == "@"
        line[new_idx] = "@"
      end
    end

    if direction == 1
      line.each_with_index do |_, idx|
        if line[idx] == "@"
          line[idx] = "."
          break
        end
      end
    else
      line.each_with_index.reverse_each do |_, idx|
        if line[idx] == "@"
          line[idx] = "."
          break
        end
      end
    end
  end

  true
end

def move_down
  CHAMBER.each_index do |chamber_idx|
    line = CHAMBER[chamber_idx]
    next unless line.include?("@")

    line.each_index do |line_idx|
      next unless line[line_idx] == "@"
      new_chamber_idx = chamber_idx + 1
      if new_chamber_idx < 0 || new_chamber_idx >= CHAMBER.size || CHAMBER[new_chamber_idx][line_idx] == "#"
        return false
      end
    end
  end

  chamber = deep_copy(CHAMBER)
  CHAMBER.each_with_index.reverse_each do |_, line_idx|
    line = chamber[line_idx]
    next unless line.include?("@")

    next_line_idx = line_idx + 1

    line.each_index do |elem_idx|
      if line[elem_idx] == "@"
        CHAMBER[next_line_idx][elem_idx] = "@"
        CHAMBER[line_idx][elem_idx] = "."
      end
    end
  end

  true
end

def rest_rocks
  CHAMBER.each do |line|
    line.each_index do |idx|
      line[idx] = "#" if line[idx] == "@"
    end
  end
end

stopped_rocks = 0
while stopped_rocks < 2022
  p "stopped_rocks: #{stopped_rocks}, rocks_idx: #{rocks_idx}, directions_idx: #{directions_idx}"
  while CHAMBER.count { |line| line == EMPTY } > 3
    CHAMBER = CHAMBER[1...]
  end
  while CHAMBER.count { |line| line == EMPTY } < 3
    CHAMBER.prepend(EMPTY.dup)
  end

  rock = deep_copy(ROCKS[rocks_idx % rocks_size])
  rock.reverse_each do |line|
    CHAMBER.prepend(line)
  end

  while true
    dir = directions[directions_idx]
    directions_idx += 1
    directions_idx %= directions_size
    move_dir(dir)
    #print_chamber
    moved_down = move_down
    break unless moved_down
  end

  rest_rocks

  stopped_rocks += 1
  rocks_idx += 1
end

first_idx = CHAMBER.find_index do |line|
  line.include?("#")
end

print_chamber
p "P1: #{CHAMBER.size - 1 - first_idx}"
