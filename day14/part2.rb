#!/usr/bin/env ruby
require 'set'

obstacles = Set.new
instructions = File.read("input.txt").split("\n")
instructions.each do |inst|
  inst.split(" -> ").each_cons(2) do |from, to|
    (x0, y0) = from.split(",").map(&:to_i)
    (x1, y1) = to.split(",").map(&:to_i)
    x_range = if x1 > x0
                (x0..x1)
              else
                (x1..x0)
              end
    y_range = if y1 > y0
                (y0..y1)
              else
                (y1..y0)
              end
    x_range.each do |x|
      y_range.each do |y|
        obstacles.add({ x: x, y: y })
      end
    end
  end
end

lowest_rock = obstacles.max_by do |obs|
  obs[:y]
end

floor = lowest_rock[:y] + 2
count = 0
until obstacles.include?({ x: 500, y: 0 })
  sand = { x: 500, y: 0 }

  cannot_move = false
  while true
    if sand[:y] + 1 == floor
      cannot_move = true
    elsif obstacles.include?({ x: sand[:x], y: sand[:y] + 1 })
      if !obstacles.include?({ x: sand[:x] - 1, y: sand[:y] + 1 })
        sand[:x] -= 1
        sand[:y] += 1
      elsif !obstacles.include?({ x: sand[:x] + 1, y: sand[:y] + 1 })
        sand[:x] += 1
        sand[:y] += 1
      else
        cannot_move = true
      end
    else
      sand[:y] += 1
    end

    if cannot_move
      obstacles.add({ x: sand[:x], y: sand[:y] })
      count += 1
      break
    end
  end
end
p "P2: #{count}"
