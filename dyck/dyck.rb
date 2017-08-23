#!/usr/bin/env ruby

class Dyckword

  attr_accessor :n, :word, :board, :rank
  
  def initialize(word)
    @word = word
    @n = word.length/2
    @board = board
    @rank = rank
  end
  
  def d(i)
    index = 0
    splitword = word.scan(/e*d/)
    0.upto(i-1) do |k|
      index += splitword[k].length
    end
    return index
  end
  
  def e(i)
    index = 0
    splitword = word.scan(/d*e/)
    0.upto(i-1) do |k|
      index += splitword[k].length
    end
    return index
  end
  
  def d_num
  end
  
  def e_num
  end
  
  def board
    b = Array.new
    1.upto(n) do |i|
      b << d(i) - i
    end
    return b
  end
  
  def coversCount
    return word.scan(/de/).size
  end
  
  def covers
    covers = Array.new
    index = 0
    coversCount.times do |k|
      cover_word = self.word.dup
      index = self.word.index("de",index + 1)
      cover_word[index..(index + 1)] = "ed"
      covers << Dyckword.new(cover_word) 
    end
    return covers
  end
  
  def rank
    rank = 0
    i = 0
    board.size.times do |i|
      rank += board[i] - i - 1
      i += 1
    end
    return rank
  end
end

# # # # # # # # # # # # # # # # # # # # # # 

class DyckLattice
  attr_accessor :n, :elements
  
  def initialize(n)
    @n = n
    @elements = filter(zero)
  end
  
  def zero
    return Dyckword.new("ed"*self.n)
  end
  
  def filter(generator)
    filter = [generator]
    rankup = generator.covers
    until rankup.empty?
      thisrank = rankup
      rankup = []
      filter = filter | thisrank
      thisrank.each do |word|
          rankup |= word.covers
      end
    end
    return filter.uniq { |obj| obj.word }
  end
  
  def ideal(gen)
    return Array.new
  end

end

# # # # # # # # # # # # # # # # # # # # # # 

#system('clear')
puts "\n\n"
if ARGV[0].to_i >= 1
  n = ARGV[0].to_i
  dn = DyckLattice.new(n)
  dn.elements.each { |el| puts el.word }
end


#########################################################################################################
# THE BELOW CODE OUTPUTS THE GENERATING FUNCTIONS FOR THE DYCK LATTICES D_n UP TO THE GIVEN VALUE n
#
#f0 = Polynomial.new(1)
#
#f = Array.new
#
#f << f0
#f << f0
#
#if ARGV[0].to_i > 1
#  n = ARGV[0].to_i 
#  2.upto(n) do |n|
#    newpoly = Polynomial.new(0)
#    0.upto(n-1) do |i|
#      xterm = Polynomial.new(([0]*(i))+[1])
#      newpoly = newpoly + f[i]*f[n-1-i]*xterm
#    end
#    f << newpoly
#  end
#  0.upto(n) do |i|
#    puts "  n = #{i}"
#    puts "- "*30,"\n"
#    puts "  F_{#{i}}(q) = #{f[i].compact}"
#    puts " F'_{#{i}}(q) = #{f[i].derivative.compact}"
#    puts " F'_{#{i}}(1) = #{f[i].derivative.evalAt(1)}\t*\n\n"
#    puts " F'_{#{i}}(1) + C_#{i}*T_#{i} = #{f[i].derivative.evalAt(1) + catalan(i)*trianglular(i)}"
#    puts "- "*30
#  end
#else
#  puts "must have n > 1."
#end
#########################################################################################################

# # # # # # # # # # # # # # # # # # # # # # 

