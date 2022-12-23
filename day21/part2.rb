#!/usr/bin/env ruby
filename = File.join(File.dirname(__FILE__), "input.txt")
lines = File.read(filename).split("\n")

root = nil
TO_COMPUTE = {}
REGISTER = {}
lines.each do |line|
  (var, value) = line.split(": ")
  if var == "root"
    root = value.split(" + ")
    next
  end
  if var == "humn"
    next
  end
  number = value.scan(/-?[0-9]+/).first&.to_i
  if number
    REGISTER[var] = number
  else
    TO_COMPUTE[var] = value
  end
end

def run_computation(register, to_compute)
  to_compute.each do |key, value|
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
    if register[left] && register[right]
      res = eval("#{register[left]}#{op}#{register[right]}")
      register[key] = res
      to_compute.delete(key)
    end
  end
end

while REGISTER[root.first].nil? && REGISTER[root.last].nil?
  run_computation(REGISTER, TO_COMPUTE)
end

(look_for, match) = if REGISTER[root.first].nil?
                      root
                    else
                      root.reverse
                    end

humn = 0
while true
  comp = TO_COMPUTE.dup
  reg = REGISTER.dup

  reg["humn"] = humn
  until comp.empty?
    run_computation(reg, comp)
  end

  if reg[match] == reg[look_for]
    p "p2: #{humn}"
    break
  end

  diff = (reg[match] - reg[look_for]).abs
  if diff / 100 > 0
    humn += diff / 100
  else
    humn += 1
  end
end
