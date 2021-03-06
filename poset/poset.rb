#!/usr/bin/env ruby

class Relation < Array
  attr_accessor :a, :b
  
  def initialize(a,b)
    @a = a
    @b = b
  end
  
  def to_a
    return [a,b]
  end
end

system('clear')

relns = Array.new

(1..10).to_a.each { |i| relns << Relation.new(i,i+1) if i < 10}

relns.each { |reln| p reln.to_a}

puts
