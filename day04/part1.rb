#!/usr/bin/env ruby

lines = File.read("input.txt").split("\n")

res = 0
lines.each do |line|
  elf1, elf2 = line.split(",")
  f1, t1 = elf1.split("-").map(&:to_i)
  f2, t2 = elf2.split("-").map(&:to_i)
  if (f1 <= f2 && t1 >=t2) || (f1 >= f2 && t1 <=t2)
    res += 1
  end
end

p res
