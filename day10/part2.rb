#!/usr/bin/env ruby

CRT = Array.new(6) { Array.new(40) }

def print_crt
  CRT.each do |line|
    line.each do |elem|
      if elem == "#"
        print "#"
      else
        print " "
      end
    end
    print "\n"
  end
end

lines = File.read("input.txt").split("\n")

x = 1
cycle = 1

pos = -1
adding = false
idx = 0
while idx < lines.size do
  (opp, val) = lines[idx].split(" ")

  if cycle % 40 == 1
    pos += 1
  end

  if opp == "noop"
    # noop
  elsif adding
    adding = false
    x += val.to_i
  else
    adding = true
    idx -= 1
  end

  CRT[pos][(cycle % 40)] = if [x - 1, x, x + 1].include?(cycle % 40)
                             "#"
                           else
                             "."
                           end

  cycle += 1
  idx += 1
end

print_crt
