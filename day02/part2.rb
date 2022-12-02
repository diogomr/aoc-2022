#!/usr/bin/env ruby


# A - Rock
# B - Paper
# C - Scissors

lines = File.read("input.txt").split("\n")

WIN_SCORE = 6
DRAW_SCORE = 3

MOVE_SCORE = {
  "A" => 1,
  "B" => 2,
  "C" => 3
}

res = lines.sum do |line|
  (opp, res) = line.split(" ")


  if opp == "A"
    if res == "X"
      MOVE_SCORE["C"]
    elsif res == "Y"
      MOVE_SCORE["A"] + DRAW_SCORE
    elsif res == "Z"
      MOVE_SCORE["B"]+ WIN_SCORE
    else
      raise "Error: #{opp}, #{me}"
    end
  elsif opp == "B"
    if res == "X"
      MOVE_SCORE["A"]
    elsif res == "Y"
      MOVE_SCORE["B"] + DRAW_SCORE
    elsif res == "Z"
      MOVE_SCORE["C"]+ WIN_SCORE
    else
      raise "Error: #{opp}, #{me}"
    end
  elsif opp == "C"
    if res == "X"
      MOVE_SCORE["B"]
    elsif res == "Y"
      MOVE_SCORE["C"] + DRAW_SCORE
    elsif res == "Z"
      MOVE_SCORE["A"]+ WIN_SCORE
    else
      raise "Error: #{opp}, #{me}"
    end
  else
    raise "Error: #{opp}, #{me}"
  end
end

p res
