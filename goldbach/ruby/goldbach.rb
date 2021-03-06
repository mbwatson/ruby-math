#!/usr/bin/env ruby
require "mathn"
#################################################
class Integer
	def prime?
		return ('1' * self) !~ /^1?$|^(11+?)\1+$/
	end
end
#################################################
def time
	start = Time.now
	yield
	print "\n time elapsed: #{Time.now - start} seconds\n\n"
end
#################################################
def primes(n)
	primes_upto_n = Array.new
	2.upto(n) do |i|
		primes_upto_n << i if i.prime?
	end
	return primes_upto_n
end
#################################################
def phi(n)
	count = 0
	1.upto(n-1) do |r|
		if n.gcd(r) == 1
			count += 1
		end
	end
	return count
end
#################################################
#system("clear")
if ARGV.size == 2
	primes = primes(ARGV[0].to_i)
	time do
		lastn = 0
		ARGV[0].to_i.upto(ARGV[1].to_i) do |n|
			print "#{n}: "
				if n.prime?
					primes << n unless primes.include?(n)
				end
			0.upto(n-2) do |k|
				if primes.include?(n-k) & (n+k).prime?
					primes << n+k unless primes.include?(n+k)
#					print "(#{n},#{k}) " 
					print "(#{n-k},#{n+k}) "
#					print "#{k} "
				end
			end
			if n != lastn
				puts 
			end
			lastn = n
		end
	end
	print " #{primes.size} primes used: "
	p primes
	puts
else
	puts "\n [!] Enter exactly two integral arguments, i.e.,\"ruby <path_to>/goldbach.rb N1 N2,\" with N1 < N2.\n\n"
end
#################################################
#################################################
#integers = Array.new
#0.upto(primes.size-1) do |i|
#	p = primes[i]
#	(i).upto(primes.size-1) do |j|
#		q = primes[j]
#		print "#{p},#{q} : "
#	if p*q - phi(p*q) == p + q - 1 
#			print "* "
#			integers << (p+q)/2 if (p+q)/2 % 1 == 0
#			puts
#		else
#			puts		 
#		end
#	end
#end
# integers.uniq.sort
#################################################
#puts " n \t k \t n^2-k^2 \t phi(n^2-k^2) \t (n-1)^2-k^2 \t (n-1)^2-(k+1)^2 \t (n+k-2)(n-k-2)"
#puts "--------------------------------------------------------------------------------------------------------------------"
#time do
#	2.upto(11) do |n|
#		print " #{n}"
#		0.upto(n-1) do |k|
#			print "\t #{k} \t #{n*n-k*k} \t\t #{phi(n*n-k*k)}"
#
#			print "\t\t #{(n-1)*(n-1)-k*k}"
#			if phi(n*n-k*k) == (n-1)*(n-1)-k*k
#				print " *"
#			end
#		puts
#		end
#		puts "---------------------------------------------------------------------------------------------------------------------"
#	end
#end
#################################################
#################################################
