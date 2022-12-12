#!/usr/bin/env ruby
require 'set'

MATRIX = File.read("input.txt").split("\n").map do |line|
  line.split("")
end

start = []
goal = []

DISTANCES = []
MAX_INT = 1_000_000
MATRIX.each_index do |row|
  MATRIX[row].each_index do |col|
    if MATRIX[row][col] == "S"
      start << row
      start << col
      MATRIX[row][col] = "a"

      DISTANCES << [row, col, 0]
    elsif MATRIX[row][col] == "E"
      goal << row
      goal << col
      MATRIX[row][col] = "z"

      DISTANCES << [row, col, MAX_INT]
    else
      DISTANCES << [row, col, MAX_INT]
    end
  end
end

p "Start: #{start} => Goal: #{goal}"

NUM_ELEM = MATRIX.size * MATRIX[0].size
VISITED = Set.new

def shortest_path(goal)
  while VISITED.size < NUM_ELEM
    DISTANCES.sort_by! { |e| e[2] }

    current = DISTANCES.find do |d|
      !VISITED.include?([d[0], d[1]])
    end

    (row, col, dist) = current
    VISITED.add([row, col])

    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dx, dy|
      row_d = row + dx
      col_d = col + dy
      if row_d >= 0 && row_d < MATRIX.size && col_d >= 0 && col_d < MATRIX[0].size
        if MATRIX[row_d][col_d].ord - MATRIX[row][col].ord <= 1
          cur_dis = DISTANCES.find do |elem|
            elem[0] == row_d && elem[1] == col_d
          end

          if cur_dis[2] > dist + 1
            cur_dis[2] = dist + 1
          end
        end
      end
    end
  end

  DISTANCES.find do |d|
    d[0] == goal[0] && d[1] == goal[1]
  end
end

sp = shortest_path(goal)
p "P1: #{sp[2]}"
