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
  seen_at = false
  CHAMBER.each_index do |chamber_idx|
    line = CHAMBER[chamber_idx]
    unless line.include?("@")
      if seen_at
        break
      else
        next
      end
    end

    seen_at = true

    line.each_index do |line_idx|
      next unless line[line_idx] == "@"
      new_chamber_idx = chamber_idx + 1
      if new_chamber_idx < 0 || new_chamber_idx >= CHAMBER.size || CHAMBER[new_chamber_idx][line_idx] == "#"
        return false
      end
    end
  end

  seen_at = false
  chamber = deep_copy(CHAMBER)
  CHAMBER.each_with_index.reverse_each do |_, line_idx|
    line = chamber[line_idx]
    unless line.include?("@")
      if seen_at
        break
      else
        next
      end
    end
    seen_at = true

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

GOAL = 1000000000000

# BASE and PATTERN_HEIGHT "magic" numbers are obtained from analysing the input of part1 over 4044 stopped rocks
# BASE is the number of lines before lines start getting repeated in the same pattern
# PATTERN_HEIGHT is the number of lines of the pattern

# BASE = 25
BASE = 714
# PATTERN_HEIGHT = 53
PATTERN_HEIGHT = 2620

rocks_per_cycle = 0
cycle_baseline = 0

artificially_added = 0
stopped_rocks = 0
while (stopped_rocks + artificially_added) < GOAL
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
    moved_down = move_down
    break unless moved_down
  end

  rest_rocks

  stopped_rocks += 1
  rocks_idx += 1

  first_idx = CHAMBER.find_index do |line|
    line.include?("#")
  end

  tallest = CHAMBER.size - 1 - first_idx
  if tallest >= BASE && tallest < BASE + 5 && (rocks_idx % rocks_size == 0) && cycle_baseline == 0
    cycle_baseline = stopped_rocks
  end
  if tallest >= (BASE + PATTERN_HEIGHT) && tallest < (BASE + PATTERN_HEIGHT + 5) && (rocks_idx % rocks_size == 0) && rocks_per_cycle == 0
    rocks_per_cycle = stopped_rocks - cycle_baseline
  end
  if rocks_per_cycle > 0 && artificially_added == 0
    goal = GOAL - stopped_rocks - PATTERN_HEIGHT
    artificially_added = rocks_per_cycle * (goal / rocks_per_cycle)
  end
end

p "P2: #{CHAMBER.size - 1 - first_idx + (artificially_added / rocks_per_cycle) * PATTERN_HEIGHT}"
