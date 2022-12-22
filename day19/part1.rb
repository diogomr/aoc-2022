#!/usr/bin/env ruby
require 'set'

filename = File.join(File.dirname(__FILE__), "input.txt")
lines = File.read(filename).split("\n")

ids = Set.new
blueprints = []
lines.each do |line|
  (id, ore_robot_ore_cost, clay_robot_ore_cost, obs_robot_ore_cost, obs_robot_clay_cost, geode_robot_ore_cost, geode_robot_obs_cost) = line.scan(/[0-9]+/).map(&:to_i)
  ids.add(id)
  blueprints << {
    id: id,
    ore_robot_ore_cost: ore_robot_ore_cost,
    clay_robot_ore_cost: clay_robot_ore_cost,
    obs_robot_ore_cost: obs_robot_ore_cost,
    obs_robot_clay_cost: obs_robot_clay_cost,
    geode_robot_ore_cost: geode_robot_ore_cost,
    geode_robot_obs_cost: geode_robot_obs_cost,
    ore_robots: 1,
    clay_robots: 0,
    obs_robots: 0,
    geode_robots: 0,
    ore: 0,
    clay: 0,
    obs: 0,
    geode: 0,
    minute: 0
  }
end

geodes = {}
best = {}
until blueprints.empty? do
  blueprints.sort_by! do |blp|
    blp[:geode]
  end

  bp = blueprints.pop
  if bp[:minute] > 23
    if best[bp[:id]].nil?
      best[bp[:id]] = bp
    else
      if bp[:geode] > best[bp[:id]][:geode]
        best[bp[:id]] = bp
      end
    end
    next
  end

  if bp[:geode] > 0
    if geodes[bp[:id]].nil? || geodes[bp[:id]] > bp[:minute]
      geodes[bp[:id]] = bp[:minute]
    end
  else
    if geodes[bp[:id]] && geodes[bp[:id]] <= bp[:minute]
      next
    end
  end

  ore = bp[:ore]
  clay = bp[:clay]
  obs = bp[:obs]

  bp[:minute] += 1
  bp[:ore] += bp[:ore_robots]
  bp[:clay] += bp[:clay_robots]
  bp[:obs] += bp[:obs_robots]
  bp[:geode] += bp[:geode_robots]

  built_robot = false
  if obs >= bp[:geode_robot_obs_cost] && ore >= bp[:geode_robot_ore_cost]
    built_robot = true
    dup = bp.dup

    dup[:ore] -= dup[:geode_robot_ore_cost]
    dup[:obs] -= dup[:geode_robot_obs_cost]
    dup[:geode_robots] += 1
    blueprints << dup
  end

  if clay >= bp[:obs_robot_clay_cost] && ore >= bp[:obs_robot_ore_cost]
    built_robot = true
    dup = bp.dup

    dup[:ore] -= dup[:obs_robot_ore_cost]
    dup[:clay] -= dup[:obs_robot_clay_cost]
    dup[:obs_robots] += 1
    blueprints << dup
  end

  unless built_robot
    if ore >= bp[:clay_robot_ore_cost]
      dup = bp.dup

      dup[:ore] -= dup[:clay_robot_ore_cost]
      dup[:clay_robots] += 1
      blueprints << dup
    end

    if ore >= bp[:ore_robot_ore_cost]
      dup = bp.dup

      dup[:ore] -= dup[:ore_robot_ore_cost]
      dup[:ore_robots] += 1
      blueprints << dup
    end
  end

  wait_ore = ore < bp[:ore_robot_ore_cost] || ore < bp[:clay_robot_ore_cost] || ore < bp[:obs_robot_ore_cost] || ore < bp[:geode_robot_ore_cost]
  wait_clay = bp[:clay_robots] > 0 && clay < bp[:obs_robot_clay_cost] && (ore + bp[:ore_robots] - bp[:geode_robot_ore_cost]) < bp[:obs_robot_ore_cost] # wait for clay if building a geode_robot means obsidian_robot can't be built in the next minute
  wait_obs = bp[:obs_robots] > 0 && obs < bp[:geode_robot_obs_cost] && (ore + bp[:ore_robots] - bp[:obs_robot_ore_cost]) < bp[:geode_robot_ore_cost] # wait for obsidian if building a obsidian_robot means geode_robot can't be built in the next minute
  # we might have rounds where no robots are built, even though we could, because its optimal to wait for resource gathering and build a better robot next
  blueprints << bp.dup if wait_ore || wait_clay || wait_obs

  p "bp: #{blueprints.size}, best: #{best.size}, geode: #{bp[:geode]}, minute: #{bp[:minute]}"
end

p "best: #{best}"

sum = 0
best.each_value do |b|
  sum += b[:id] * b [:geode]
end

p "p1: #{sum}"
