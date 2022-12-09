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

x = Array.new(10) { 0 }
y = Array.new(10) { 0 }

VISITED = Set.new

lines.each do |line|
  (dir, times) = line.split(" ")
  times.to_i.times do
    case dir
    when "R"
      x[0] += 1
    when "L"
      x[0] -= 1
    when "U"
      y[0] += 1
    when "D"
      y[0] -= 1
    else
      raise "Unexpected #{dir}"
    end

    x.each_index.each_cons(2) do |first, second|
      unless around(x[first], y[first], x[second], y[second])
        found = false

        [-1, 0, 1].each do |dx|
          [-1, 0, 1].each do |dy|
            if !found && around(x[first], y[first], x[second] + dx, y[second] + dy, false)
              x[second] += dx
              y[second] += dy
              found = true
            end
          end
        end

        [-1, 0, 1].each do |dx|
          [-1, 0, 1].each do |dy|
            if !found && around(x[first], y[first], x[second] + dx, y[second] + dy, true)
              x[second] += dx
              y[second] += dy
              found = true
            end
          end
        end
      end
    end

    VISITED << "#{x.last},#{y.last}"
  end
end

p VISITED.size
