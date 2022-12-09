#!/usr/bin/env ruby
require 'set'

lines = File.read("input.txt").split("\n")

def around(hx, hy, tx, ty, diag = true)
  dx = (hx - tx).abs
  dy = (hy - ty).abs
  res = dx <= 1 && dy <= 1
  if diag
    res
  else
    res && (dx == 0 || dy == 0)
  end
end

hx = 0
hy = 0
tx = 0
ty = 0

VISITED = Set.new
lines.each do |line|
  (dir, times) = line.split(" ")
  times.to_i.times do
    case dir
    when "R"
      hx += 1
    when "L"
      hx -= 1
    when "U"
      hy += 1
    when "D"
      hy -= 1
    else
      raise "Unexpected #{dir}"
    end

    unless around(hx, hy, tx, ty)
      found = false

      [-1, 0, 1].each do |dx|
        [-1, 0, 1].each do |dy|
          if !found && around(hx, hy, tx + dx, ty + dy, false)
            tx += dx
            ty += dy
            found = true
          end
        end
      end
    end

    VISITED << "#{tx},#{ty}"
  end
end

p VISITED.size
