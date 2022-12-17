#!/usr/bin/env ruby

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

filename = File.join(File.dirname(__FILE__), "input.txt")
lines = File.read(filename).split("\n")

MAP = {}
lines.each do |line|
  (valve, tunnels) = line.split("; ")
  id = valve.scan(/[A-Z]{2}/).first
  rate = valve.scan(/[0-9]+/).map(&:to_i).first
  tunnels = tunnels.scan(/[A-Z]{2}/)

  MAP[id] = {
    rate: rate,
    tunnels: tunnels
  }
end

initial = {
  current: "AA",
  left: 30,
  flow: 0,
  opened: []
}

def best_attainable_flow(state)
  max = state[:flow]
  left = state[:left]
  MAP.sort_by do |k,v|
    -v[:rate]
  end.each do |k,v|
    unless state[:opened].include?(k)
      max += left * v[:rate]
      left -= 2
    end
  end
  max
end

max_flow = 0
STATES = [initial]
while true
  STATES.sort_by! do |st|
    -st[:flow]
  end
  state = STATES.find do |st|
    st[:left] > 0
  end
  break if state.nil?
  STATES.delete(state)

  if best_attainable_flow(state) < max_flow
    next
  end

  current = state[:current]
  valve = MAP[current]

  if valve[:rate] != 0 && !state[:opened].include?(current)
    # open valve
    ns = deep_copy(state)
    ns[:left] -= 1
    ns[:opened] << current
    ns[:flow] += (valve[:rate] * ns[:left])
    if ns[:flow] > max_flow
      max_flow = ns[:flow]
    end
    STATES << ns
  end

  valve[:tunnels].each do |tun|
    # go to tunnel
    ns = deep_copy(state)
    ns[:left] -= 1
    ns[:current] = tun
    STATES << ns
  end
end

p "P1: #{max_flow}"
