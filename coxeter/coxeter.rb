#!/usr/bin/env ruby
require './coxeterlib.rb'
#################################################
def time
	start = Time.now
	yield
	puts "[time elapsed: #{Time.now - start} seconds]".rjust(50)
end
#################################################
#system('clear')

type = ARGV[0].capitalize
n = ARGV[1].to_i

time do
  g = CoxeterGroup.new(type,n)
  g.print_summary
end

#graph = BruhatGraph.new(g)
#graph.make_dot_file("#{type}_#{n}")
#system "xdot #{type}_#{n}.dot" if ARGV[2] == "view"

