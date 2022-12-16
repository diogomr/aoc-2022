#!/usr/bin/env ruby
require 'set'
def distance(a, b)
  (a.first - b.first).abs + (a.last - b.last).abs
end

def compute_free_space(sensor, beacon, relevant_y)
  free = []
  d = distance(sensor, beacon)

  p "d: #{d}"
  return [] if sensor.last - d > relevant_y || sensor.last + d < relevant_y
  (-d..d).each do |dx|
      (x, _) = sensor
      d2 = distance(sensor, [x + dx, relevant_y])
      if d2 <= d
        free << [x + dx, relevant_y]
      end
  end
  free
end

relevant_y = 2000000
free = Set.new
sensors = []
beacons = []
lines = File.read("input.txt").split("\n")
lines.each do |line|
  (sx, sy, bx, by) = line.scan(/-?[0-9]+/).map(&:to_i)

  sensor = [sx, sy]
  beacon = [bx, by]

  compute_free_space(sensor, beacon, relevant_y).each do |fs|
    free.add(fs)
  end

  sensors << sensor
  beacons << beacon
end

p1 = free.filter do |fs|
  fs.last == relevant_y && !sensors.include?(fs) && !beacons.include?(fs)
end.size

p "P1: #{p1}"
