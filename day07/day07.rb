#!/usr/bin/env ruby

def insert(hash, path, key, value)
  if path.empty?
    hash[key] ||= {}
    hash[key] = value
  else
    insert(hash[path[0]], path[1..], key, value)
  end
end

FS = { "/" => {} }
PATH = []

lines = File.read("input.txt").split("\n")

lines.each do |line|
  first, second, third = line.split(" ")
  if first == "$"
    # cmd
    if second == "cd"
      # change dir
      if third == "/"
        PATH = ["/"]
      elsif third == ".."
        PATH.pop
      else
        PATH << third
      end
    elsif second == "ls"
      # list dir
      # noop
    end
  elsif first == "dir"
    # directory
    insert(FS, PATH, second, {})
  else
    # file
    insert(FS, PATH, second, first.to_i)
  end
end

def compute_dir_sizes(hash, key, sizes)
  hash.each do |k, v|
    if v.instance_of? Hash
      new_key = key + k
      sizes[new_key] = count_dir_size(v)
      compute_dir_sizes(v, new_key, sizes)
    end
  end
end

def count_dir_size(hash)
  sum = 0
  hash.each do |k, v|
    if v.instance_of? Hash
      sum += count_dir_size(v)
    else
      sum += v
    end
  end
  sum
end

SIZES = {}
compute_dir_sizes(FS, "", SIZES)

res = 0
SIZES.each do |k, v|
  if v <= 100000
    res += v
  end
end

p "p1: #{res}"

TOTAL_FS_SIZE = 70000000
FREE_SIZE_GOAL = 30000000
CURRENT_USAGE = SIZES["/"]

CURRENT_FREE = TOTAL_FS_SIZE - CURRENT_USAGE
MIN_DELETE_SIZE = FREE_SIZE_GOAL - CURRENT_FREE

CANDIDATES = []
SIZES.each do |k, v|
  if v >= MIN_DELETE_SIZE
    CANDIDATES << v
  end
end

p "p2: #{CANDIDATES.min}"
