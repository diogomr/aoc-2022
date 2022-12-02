#!/usr/bin/env ruby

lines = File.read("input.txt").split("\n")

WIN_SCORE = 6
DRAW_SCORE = 3

MOVE_SCORING = {
  A: {
    X: 1 + DRAW_SCORE,
    Y: 2 + WIN_SCORE,
    Z: 3
  },
  B: {
    X: 1,
    Y: 2 + DRAW_SCORE,
    Z: 3 + WIN_SCORE
  },
  C: {
    X: 1 + WIN_SCORE,
    Y: 2,
    Z: 3 + DRAW_SCORE
  }
}


res = lines.sum do |line|
  (opp, me) = line.split(" ")

  MOVE_SCORING[opp.to_sym][me.to_sym]
end

p res
