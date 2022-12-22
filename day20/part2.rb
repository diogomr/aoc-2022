#!/usr/bin/env ruby
filename = File.join(File.dirname(__FILE__), "input.txt")
lines = File.read(filename).split("\n")

DECRYPTION_KEY = 811589153
file = []
lines.each_with_index do |num, pos|
  file << { num: num.to_i * DECRYPTION_KEY, pos: pos }
end

def pretty_print(state)
  p "[#{state.map { |s| s[:num] }.join(", ") }]"
end

size = file.size
state = file.dup
10.times do
  file.each do |line|
    idx = state.find_index { |s| s == line }
    new_idx = (idx + line[:num]) % (size - 1)
    state.delete_at(idx)
    state = state[...new_idx] + [line] + state[new_idx...]
  end
end

zero_idx = state.find_index { |s| s[:num] == 0 }
first = state[(zero_idx + 1000) % size][:num]
second = state[(zero_idx + 2000) % size][:num]
third = state[(zero_idx + 3000) % size][:num]

p "p2: #{first} + #{second} + #{third} = #{first + second + third}"
