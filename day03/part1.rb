#!/usr/bin/env ruby

UPPERCASE_ORD_BASELINE = 64 - 26
DOWNCASE_ORD_BASELINE = 96

def split_middle(line)
  [line[0...line.size / 2], line[line.size / 2, line.size]]
end

def downcase?(char)
  char.ord > 90
end

lines = File.read("input.txt").split("\n")

sum = 0
lines.each do |line|
  p1, p2 = split_middle(line)
  p1.each_char do |p1c|
    if p2.include?(p1c)
      value = if downcase?(p1c)
                p1c.ord - DOWNCASE_ORD_BASELINE
              else
                p1c.ord - UPPERCASE_ORD_BASELINE
              end
      sum += value
      break
    end
  end
end
p sum
