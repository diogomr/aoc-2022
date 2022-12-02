#!/usr/bin/env ruby

lines = File.read("input.txt").split("\n")

MOVE_SCORE = {
  "X" => 1,
  "Y" => 2,
  "Z" => 3
}
WIN_SCORE = 6
DRAW_SCORE = 3

res = lines.sum do |line|
  (opp, me) = line.split(" ")

  if opp == "A"
    if me == "X"
      MOVE_SCORE[me] + DRAW_SCORE
    elsif me == "Y"
      MOVE_SCORE[me] + WIN_SCORE
    elsif me == "Z"
      MOVE_SCORE[me]
    else
      raise "Error: #{opp}, #{me}"
    end
  elsif opp == "B"
    if me == "X"
      MOVE_SCORE[me]
    elsif me == "Y"
      MOVE_SCORE[me] + DRAW_SCORE
    elsif me == "Z"
      MOVE_SCORE[me] + WIN_SCORE
    else
      raise "Error: #{opp}, #{me}"
    end
  elsif opp == "C"
    if me == "X"
      MOVE_SCORE[me] + WIN_SCORE
    elsif me == "Y"
      MOVE_SCORE[me]
    elsif me == "Z"
      MOVE_SCORE[me] + DRAW_SCORE
    else
      raise "Error: #{opp}, #{me}"
    end
  else
    raise "Error: #{opp}, #{me}"
  end
end

p res
