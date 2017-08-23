#################################################
################### GLOBAL ######################
#################################################

class Matrix
  def nice(preface)
    return self.to_a.each.map{ |row| "#{preface}#{row}\n" }
  end
  
  def []=(i, j, x)
    @rows[i][j] = x
  end
end
#################################################
################### ARRAY #######################
#################################################
class Array
  def subset?(arr)
    return (self-arr).empty?
  end
  
  def supset?(arr)
    return (arr-self).empty?
  end
end
#################################################
################ PERMUTATION ####################
#################################################
class Permutation < Hash
  # returns the set of generators that reduce inversion number
  def inversions
    descents = Array.new
    self.keys.combination(2).map { |i,j| descents << [i,j] if self[i] > self[j] }
    return descents
  end
  
  def compact
    return "[#{self.sort.map{|k,v| v}.join(",")}]"
  end
  
  def isFixedPointFree?
    if self.select{ |key,value| key == value }.size == 0
      return true
    else
      return false
    end
  end
end 
#################################################
################## TYPE A #######################
#################################################
class Aperm < Permutation
  
  attr_accessor :n
  @n = Array(self).size
  
  # returns string version of permutation in one-line notation
  def to_s
    return '['+self.values.join(',')+']'
  end
  
  # returns the inversion number
  def rank
    inv_num = 0
    1.upto(size-1) do |i|
      (i+1).upto(size) do |j|
        inv_num += 1 if self[i] > self[j]
      end
    end
    return inv_num
  end
    
  # returns the set of rises
  def rises
    rises = Array.new
    1.upto(size-1) do |i|
      (i+1).upto(size) do |j|
        rises << [i,j] if self[i] < self[j]
      end
    end
    return rises
  end
  
  # returns the set of inversions
  def inversions
    inversions = Array.new
    1.upto(size-1) do |i|
      (i+1).upto(size) do |j|
        inversions << [i,j] if self[i] > self[j]
      end
    end
    return inversions
  end
  
  # returns boolean of first perm is bruhat less than second, using Bj-Br matrix
#  def compareBruhat(x,y)
#    n = x.length
#    comparable = true
#    i_set = Array.new
#    if n == y.length then
#      1.upto(n) do |i|
#        i.upto(n) do |j|
#        end
#      end
#    else return :invalid_perms
#    end
#  end
  
end
#################################################
################## TYPE B #######################
#################################################
class Bperm < Permutation  
  def inverse
    p self
    inv = Bperm.new
    self.each do |key,value|
      case
        when value < 0
          inv[-1*value] = -1*key
        when value > 0
          inv[value] = key
      end
    end
    return inv
  end
  
  # returns ith value of permutation, accounts for negative positions
  def [](i)
    case
      when i > 0
        return self.fetch(i)
      when i < 0
        return -self[-i]
    end
  end
  
  # returns inv, neg, nsp: used to compute rank
  def inv
    inv_num = 0
    1.upto(size-1) do |i|
      (i+1).upto(size) do |j|
        inv_num += 1 if self[i] > self[j]
      end
    end
    return inv_num
  end
  def neg
    return self.values.select { |i| i < 0 }.size
  end
  def nsp
    return self.values.combination(2).to_a.select { |pair| pair[0] + pair[1] < 0 }.size
  end
  
  # returns the rank = inv + neg + nsp
  def rank
    return inv + neg + nsp
  end
    
  # returns the set of rises
  def rises
    rises = Array.new
    1.upto(size-1) do |i|
      rises << [i,-i] if self[i] >= i
      (i+1).upto(size) do |j|
        rises << [i,j] if self[i] < self[j]
      end
    end
    return rises
  end
  
  def complete
    return self.sort.map { |k,v| "#{k.inspect} => #{v.inspect}" }.join(", ")
  end
  
end
#################################################
