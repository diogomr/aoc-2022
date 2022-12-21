#!/usr/bin/env ruby
filename = File.join(File.dirname(__FILE__), "input.txt")
lines = File.read(filename).split("\n")

exposed_sides = lines.size * 6
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

cubes.each_index do |idx|
  (idx + 1...cubes.size).each do |idx2|
    if touching(cubes[idx], cubes[idx2])
      exposed_sides -= 2
    end
  end
end

p "P1: #{exposed_sides}"
