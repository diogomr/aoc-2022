#!/usr/bin/env ruby

lines = File.read("input.txt").split("\n")

WIN_SCORE = 6
DRAW_SCORE = 3

MOVE_SCORING = {
  A: {
    X: 3,
    Y: 1 + DRAW_SCORE,
    Z: 2 + WIN_SCORE
  },
  B: {
    X: 1,
    Y: 2 + DRAW_SCORE,
    Z: 3 + WIN_SCORE
  },
  C: {
    X: 2,
    Y: 3 + DRAW_SCORE,
    Z: 1 + WIN_SCORE
  }
}

res = lines.sum do |line|
  (opp, res) = line.split(" ")
  MOVE_SCORING[opp.to_sym][res.to_sym]
end

p res
