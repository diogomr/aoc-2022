#!/usr/bin/env ruby

lines = File.read("input.txt").split("\n")

res = 0
lines.each do |line|
  elf1, elf2 = line.split(",")
  f1, t1 = elf1.split("-").map(&:to_i)
  f2, t2 = elf2.split("-").map(&:to_i)

  elf1_range = (f1..t1)
  elf2_range = (f2..t2)

  if elf1_range.cover?(f2) || elf1_range.cover?(t2) || elf2_range.cover?(f1) || elf2_range.cover?(t1)
    res += 1
  end
end

p res
