#!/usr/bin/env ruby

MAP = []
lines = File.read("input.txt").split("\n")
lines.each do |line|
  MAP << line.split("")
end

best_score = 0
(1..MAP.size - 1).each do |x|
  (1..MAP.size - 1).each do |y|
    dxmin = (0..x - 1)
    dxmax = (x + 1..MAP.size - 1)

    dymin = (0..y - 1)
    dymax = (y + 1..MAP.size - 1)

    up, down, left, right = 0, 0, 0, 0

    dxmin.reverse_each do |dx|
      up += 1
      if MAP[x][y] <= MAP[dx][y]
        break
      end
    end

    dxmax.each do |dx|
      down += 1
      if MAP[x][y] <= MAP[dx][y]
        break
      end
    end

    dymin.reverse_each do |dy|
      left += 1
      if MAP[x][y] <= MAP[x][dy]
        break
      end
    end

    dymax.each do |dy|
      right += 1
      if MAP[x][y] <= MAP[x][dy]
        break
      end
    end

    score = up * down * left * right
    if score > best_score
      best_score = score
    end
  end
end

p best_score
