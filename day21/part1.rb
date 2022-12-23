#!/usr/bin/env ruby
filename = File.join(File.dirname(__FILE__), "input.txt")
lines = File.read(filename).split("\n")

TO_COMPUTE = {}
REGISTER = {}
lines.each do |line|
  (var, value) = line.split(": ")
  number = value.scan(/-?[0-9]+/).first&.to_i
  if number
    REGISTER[var] = number
  else
    TO_COMPUTE[var] = value
  end
end

until TO_COMPUTE.empty?
  TO_COMPUTE.each do |key, value|
    op = if value.include?(" + ")
           " + "
         elsif value.include?(" - ")
           " - "
         elsif value.include?(" / ")
           " / "
         elsif value.include?(" * ")
           " * "
         else
           raise "Missing op"
         end

    (left, right) = value.split(op)
    if REGISTER[left] && REGISTER[right]
      res = eval("#{REGISTER[left]}#{op}#{REGISTER[right]}")
      REGISTER[key] = res
      TO_COMPUTE.delete(key)
    end
  end
end

p "p1: #{REGISTER["root"]}"
