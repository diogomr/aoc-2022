#!/usr/bin/env ruby

# 1 right order, 0 inconclusive, -1 wrong order
def right_order?(left, right)
  if left.instance_of? Integer
    if right.instance_of? Integer
      if left < right
        1
      elsif left > right
        -1
      else
        0
      end
    else
      right_order?([left], right)
    end
  else
    # left is array
    if right.instance_of? Integer
      right_order?(left, [right])
    else
      size = [left.size, right.size].max
      (0..size - 1).each do |idx|
        return -1 if idx < left.size && idx >= right.size
        return 1 if idx < right.size && idx >= left.size
        res = right_order?(left[idx], right[idx])
        if res != 0
          return res
        end
      end
      return 0
    end
  end
end

first = [[2]]
second = [[6]]
all = [first, second]
sum = 0
groups = File.read("input.txt").split("\n\n")
groups.each.with_index do |group, idx|
  (left, right) = group.split("\n")
  left = eval(left)
  right = eval(right)

  all << left
  all << right

  res = right_order?(left, right)
  sum += idx + 1 if res == 1
end

p "p1: #{sum}"

all.sort! do |e1, e2|
  right_order?(e2, e1) <=> 0
end

p2 = (all.find_index(first) + 1) * (all.find_index(second) + 1)
p "p2: #{p2}"
