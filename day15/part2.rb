#!/usr/bin/env ruby
require 'set'

MAX_COORD = 4_000_000
MIN_COORD = 0

def distance(a, b)
  (a.first - b.first).abs + (a.last - b.last).abs
end

sensors = []
beacons = []
distances = []
lines = File.read("input.txt").split("\n")
lines.each do |line|
  (sx, sy, bx, by) = line.scan(/-?[0-9]+/).map(&:to_i)

  sensor = [sx, sy]
  beacon = [bx, by]

  sensors << sensor
  beacons << beacon
  distances << distance(sensor, beacon)
end

x = 0
y = 0
while true
  not_colliding = true
  sensors.each.with_index do |sensor, idx|

    dist = distance([x, y], sensor)
    if dist == 0
      not_colliding = false
      next
    end

    if dist <= distances[idx]
      not_colliding = false
      diff = (distances[idx] - dist).abs
      y += diff
      if y > MAX_COORD
        x += 1
        y = 0
      end
    end
  end

  if not_colliding && x <= MAX_COORD && y <= MAX_COORD
    p "Resp: (#{x}, #{y})"
    p "P2: #{x * 4000000 + y}"
    return
  else
    y += 1
  end
end
