#!/usr/bin/env ruby

(lines,_) = File.read("input.txt").split("\n")

BLOCK_SIZE = 14

count = 0
lines.split("").each_cons(BLOCK_SIZE) do |block|
  if block == block.uniq
    break
  end
  count+=1
end

p count + BLOCK_SIZE
