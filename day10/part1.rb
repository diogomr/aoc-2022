#!/usr/bin/env ruby

x = 1
cycle = 1
sum = 0

lines = File.read("input.txt").split("\n")

adding = false
idx = 0
while idx < lines.size do
  (opp, val) = lines[idx].split(" ")
  cycle += 1
  if opp == "noop"
    # noop
  elsif adding
    adding = false
    x += val.to_i
  else
    adding = true
    idx -= 1
  end

  if [20, 60, 100, 140, 180, 220].include?(cycle)
    sum += (x * cycle)
  end

  idx += 1
end

p sum
