#!/usr/bin/env ruby

input = File.read("input.txt")

puts input.split("\n\n")
          .map { |line| line.split("\n").map(&:to_i).sum }
          .sort
          .reverse
          .take(3)
          .sum
