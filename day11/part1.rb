#!/usr/bin/env ruby

monkeys = File.read("input.txt").split("\n\n")

STATE = {}
monkeys.each do |monkey|
  attributes = monkey.split("\n")
  id = attributes[0].scan(/[0-9]+/).first.to_i
  items = attributes[1].scan(/[0-9]+/).map(&:to_i)

  opValue = attributes[2].scan(/[0-9]+/).first.to_i
  op = if attributes[2].include? "*"
         lambda do |x|
           if opValue == 0
             x * x
           else
             opValue * x
           end
         end
       else
         lambda do |x|
           opValue + x
         end
       end

  testValue = attributes[3].scan(/[0-9]+/).first.to_i
  test = lambda do |x|
    x % testValue == 0
  end

  trueThrow = attributes[4].scan(/[0-9]+/).first.to_i
  falseThrow = attributes[5].scan(/[0-9]+/).first.to_i

  STATE[id] = {
    items: items,
    op: op,
    test: test,
    trueThrow: trueThrow,
    falseThrow: falseThrow,
    count: 0
  }
end

rounds = 20

rounds.times do |round|
  monkeys.each_index do |mIdx|
    monkey = STATE[mIdx]
    monkey[:items].each do |item|
      res = monkey[:op].call(item) / 3
      throwMonkey = if monkey[:test].call(res)
                      monkey[:trueThrow]
                    else
                      monkey[:falseThrow]
                    end
      STATE[throwMonkey][:items] << res
      STATE[mIdx][:count] += 1
    end
    monkey[:items] = []
  end
end

(a, b) = STATE.values.map { |value| value[:count] }.sort.last(2)
p a * b
