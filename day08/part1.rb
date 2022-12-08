#!/usr/bin/env ruby

MAP = []
lines = File.read("input.txt").split("\n")
lines.each do |line|
  MAP << line.split("")
end

visible = MAP.size * 2 + (MAP.size - 2) * 2
(1..MAP.size - 2).each do |x|
  dxmin = (0..x - 1)
  dxmax = (x + 1..MAP.size - 1)
  (1..MAP.size - 2).each do |y|
    if dxmin.all? { |dx| MAP[x][y] > MAP[dx][y] }
      visible += 1
      next
    end
    if dxmax.all? { |dx| MAP[x][y] > MAP[dx][y] }
      visible += 1
      next
    end
    dymin = (0..y - 1)
    if dymin.all? { |dy| MAP[x][y] > MAP[x][dy] }
      visible += 1
      next
    end
    dymax = (y + 1..MAP.size - 1)
    if dymax.all? { |dy| MAP[x][y] > MAP[x][dy] }
      visible += 1
      next
    end
  end
end

p visible
