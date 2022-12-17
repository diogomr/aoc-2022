#!/usr/bin/env ruby
require 'set'

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

MAP.values do |elem|
  elem[:tunnels].sort_by! do |tun|
    -MAP[tun][:rate]
  end
end

initial = {
  prev: nil,
  current: "AA",
  elephant_prev: nil,
  elephant: "AA",
  left: 26,
  flow: 0,
  opened: Set.new
}

def best_attainable_flow(state)
  max = state[:flow]
  left = state[:left]

  if MAP[state[:current]][:rate] == 0 || MAP[state[:elephant]][:rate] == 0
    left -= 2
  end

  MAP.entries.filter do |elem|
    !state[:opened].include?(elem.first)
  end.sort_by! do |elem|
    -elem.last[:rate]
  end.each_slice(2) do |e1, e2|
    break if left <= 0
    first_rate = e1.last[:rate]
    second_rate = e2 ? e2.last[:rate] : 0
    max += (first_rate + second_rate) * left
    left -= 2
  end
  max
end

VISITED = {}
max_flow = 0
STATES = [initial]
while true
  STATES.sort_by! do |st|
    st[:flow]
  end

  state = STATES.pop
  break if state.nil?
  next unless state[:left] > 0
  next unless best_attainable_flow(state) > max_flow

  new_states = []
  current = state[:current]
  valve = MAP[current]
  if valve[:rate] != 0 && !state[:opened].include?(current)
    # open valve
    ns = deep_copy(state)
    ns[:prev] = nil
    ns[:left] -= 1
    ns[:opened].add(current)
    ns[:flow] += (valve[:rate] * ns[:left])
    if ns[:flow] > max_flow
      max_flow = ns[:flow]
      p "Left: #{ns[:left]}, Flow: #{ns[:flow]}, Size: #{STATES.size}, Visited: #{VISITED.size}"
    end
    new_states << ns
  end

  valve[:tunnels].each do |tun|
    next if state[:elephant] == tun || state[:prev] == tun || state[:elephant_prev] == tun
    # go to tunnel
    ns = deep_copy(state)
    ns[:left] -= 1
    ns[:prev] = ns[:current]
    ns[:current] = tun
    new_states << ns
  end

  new_states.each do |st|
    current = st[:elephant]
    valve = MAP[current]

    if valve[:rate] != 0 && !st[:opened].include?(current)
      # open valve
      ns = deep_copy(st)
      ns[:elephant_prev] = nil
      ns[:opened].add(current)
      ns[:flow] += (valve[:rate] * ns[:left])
      if ns[:flow] > max_flow
        max_flow = ns[:flow]
        p "Left: #{ns[:left]}, Flow: #{ns[:flow]}, Size: #{STATES.size}, Visited: #{VISITED.size}"
      end

      if (value = VISITED[{ current: ns[:current], elephant: ns[:elephant], left: ns[:left], opened: ns[:opened] }])
        if ns[:flow] > value
          VISITED[{ current: ns[:current], elephant: ns[:elephant], left: ns[:left], opened: ns[:opened] }] = ns[:flow]
        else
          next
        end
      elsif (value = VISITED[{ current: ns[:elephant], elephant: ns[:current], left: ns[:left], opened: ns[:opened] }])
        if ns[:flow] > value
          VISITED[{ current: ns[:elephant], elephant: ns[:current], left: ns[:left], opened: ns[:opened] }] = ns[:flow]
        else
          next
        end
      else
        VISITED[{ current: ns[:current], elephant: ns[:elephant], left: ns[:left], opened: ns[:opened] }] = ns[:flow]
      end
      STATES << ns
    end

    valve[:tunnels].each do |tun|
      next if st[:current] == tun || st[:prev] == tun || st[:elephant_prev] == tun
      # go to tunnel
      ns = deep_copy(st)
      ns[:elephant_prev] = ns[:elephant]
      ns[:elephant] = tun

      if (value = VISITED[{ current: ns[:current], elephant: ns[:elephant], left: ns[:left], opened: ns[:opened] }])
        if ns[:flow] > value
          VISITED[{ current: ns[:current], elephant: ns[:elephant], left: ns[:left], opened: ns[:opened] }] = ns[:flow]
        else
          next
        end
      elsif (value = VISITED[{ current: ns[:elephant], elephant: ns[:current], left: ns[:left], opened: ns[:opened] }])
        if ns[:flow] > value
          VISITED[{ current: ns[:elephant], elephant: ns[:current], left: ns[:left], opened: ns[:opened] }] = ns[:flow]
        else
          next
        end
      else
        VISITED[{ current: ns[:current], elephant: ns[:elephant], left: ns[:left], opened: ns[:opened] }] = ns[:flow]
      end
      STATES << ns
    end
  end
end

p "P2: #{max_flow}"
