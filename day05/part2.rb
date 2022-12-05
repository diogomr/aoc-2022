#!/usr/bin/env ruby

def crane_idx(pos)
  if pos == 1
    1
  else
    4 + crane_idx(pos - 1)
  end
end

lines = File.read("input.txt").split("\n")
INPUT_SEPARATOR = lines.find_index("")

CRANE = {}

state = lines.take(INPUT_SEPARATOR-1)
lines[INPUT_SEPARATOR-1].split(" ").each do  |pos|
  CRANE[pos] = {pile: []}
end

state.reverse.each do |line|
  CRANE.each_key do |k|
    idx = crane_idx(k.to_s.to_i)
    CRANE[k][:pile] << line[idx] unless line[idx].nil? || line[idx] !~ /[A-Z]+/
  end
end

instructions = lines.drop(INPUT_SEPARATOR+1)
instructions.each do |line|

  regex= /move ([0-9]+) from ([0-9]+) to ([0-9]+)/
  num, from, to = [line[regex, 1], line[regex, 2], line[regex, 3]]

  to_move = []
  num.to_i.times do
    to_move.prepend(CRANE[from][:pile].pop)
  end
  CRANE[to][:pile].append(*to_move)
end

res = ""
CRANE.each_value do |value|
  res += value[:pile].pop
end
p res
