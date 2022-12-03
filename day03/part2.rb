#!/usr/bin/env ruby

UPPERCASE_ORD_BASELINE = ("A".ord - 1) - 26
DOWNCASE_ORD_BASELINE = ("a".ord) - 1

def downcase?(char)
  char.ord > "Z".ord
end

lines = File.read("input.txt").split("\n").each_slice(3).to_a

sum = 0
lines.each do |line|

  elf1, elf2, elf3 = line

  elf1.each_char do |p1c|
    if elf2.include?(p1c) && elf3.include?(p1c)
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
