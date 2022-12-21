#!/usr/bin/env ruby
require 'set'

filename = File.join(File.dirname(__FILE__), "input.txt")
lines = File.read(filename).split("\n")

cubes = []
lines.each do |line|
  (x, y, z) = line.split(",").map(&:to_i)
  cubes << [x, y, z]
end

def touching(first, second)
  if first[0] == second[0] && first[1] == second[1] && (first[2] - second[2]).abs == 1
    true
  elsif first[0] == second[0] && (first[1] - second[1]).abs == 1 && first[2] == second[2]
    true
  elsif (first[0] - second[0]).abs == 1 && first[1] == second[1] && first[2] == second[2]
    true
  else
    false
  end
end

max_x_cube = cubes.max_by do |cube|
  cube[0]
end
max_y_cube = cubes.max_by do |cube|
  cube[1]
end
max_z_cube = cubes.max_by do |cube|
  cube[2]
end

MAX_X = max_x_cube[0]
MAX_Y = max_y_cube[1]
MAX_Z = max_z_cube[2]

EXIT_CACHE = {}

def find_exit(exits, cubes, visited = Set.new)
  new_exits = []

  exits.each do |ex|
    next if cubes.include?(ex)

    (x, y, z) = ex

    return ex if (x > MAX_X + 1 || x < -1)
    return ex if (y > MAX_Y + 1 || y < -1)
    return ex if (z > MAX_Z + 1 || z < -1)

    [-1, 1].each do |d|
      new_exits << [x + d, y, z] unless visited.include?([x + d, y, z])
      new_exits << [x, y + d, z] unless visited.include?([x, y + d, z])
      new_exits << [x, y, z + d] unless visited.include?([x, y, z + d])

      visited.add [x + d, y, z]
      visited.add [x, y + d, z]
      visited.add [x, y, z + d]
    end
  end

  if new_exits.empty?
    nil
  else
    find_exit(new_exits, cubes, visited)
  end
end

def trapped(air, cubes)
  if EXIT_CACHE[air].nil?
    ex = find_exit([air], cubes)
    res = if ex.nil?
            true
          else
            false
          end
    EXIT_CACHE[air] = res
    res
  else
    EXIT_CACHE[air]
  end
end

exposed_sides = 0
(-1..MAX_X + 1).each do |x|
  (-1..MAX_Y + 1).each do |y|
    (-1..MAX_Z + 1).each do |z|
      air = [x, y, z]
      next if cubes.include?(air)
      touch_count = 0
      cubes.each_index do |idx|
        if touching(cubes[idx], air)
          touch_count += 1
        end
      end

      exposed_sides += touch_count unless trapped(air, cubes)
    end
  end
end

p "P2: #{exposed_sides}"
