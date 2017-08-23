require 'matrix'
require './permlib.rb'
#################################################
############# COXETER GROUP #####################
#################################################
class CoxeterGroup
  attr_accessor :type, :n, :generators, :reflections, :elements
  
  def initialize(type,n)
    @type = type
    @n = n
    @generators = generator_set
    @reflections = reflection_set
#    @elements = elements
  end
  
  # returns the generator set of the group
  def generator_set
    generators = Array.new
    case type
      when "A"
        1.upto(n) do |i|
          generators << t(i,i+1)
        end
      when "B"
        generators << s(0)
        1.upto(n-1) do |i|
          generators << t(i,i+1)
        end
      when "D"
        2.upto(n) do |i|
          generators << t(1,i)
        end
        generators << s(0)
      when "I"
        gen = identity
        generators << gen.each { |key,value| gen[key] = n - value + 1 }
        gen = identity
        2.upto(((n+1)/2).floor) do |i|
          gen = product(gen,t(i,n - i + 2))
        end
        generators << gen
    end
    return generators
  end
  
  # returns the set of reflections of the group
  def reflection_set
    reflections = Array.new
    case type
      when "A"
        1.upto(n) do |i|
          (i+1).upto(n+1) do |j|
            reflections << t(i,j)
          end
        end
      when "B"
        1.upto(n-1) do |i|
          (i+1).upto(n) do |j|
            reflections << t(i,j)
            reflections << t(i,-j)
          end
        end
        1.upto(n) do |i|
          reflections << product(t(1,i),product(s(0),t(1,i)))
        end
      when "D"
        1.upto(n-1) do |i|
          (i+1).upto(n) do |j|
            reflections << t(i,j)
            reflections << t(i,-j)
          end
        end
      when "I"
        case
          when n % 2 == 1
            1.upto(n) do |i|
              gen = identity
              reflections << gen.each { |key,value| gen[key] = (i - value)%n + 1 }
            end
          when n % 2 == 0
            rotation = identity
            rotation = rotation.each { |key,value| rotation[key] = n - value + 1 }
            1.upto(n) do |i|
              gen = identity
              reflections << gen.each { |key,value| gen[key] = (i - value)%n + 1 }
            end
        end
    end
    return reflections
  end
  
  # returns the elements of the group
  def elements
    elements = Array.new
    case type
      when "A"
        (1..n+1).map{ |i| i }.permutation(n+1).map{ |perm| perm }.each do |perm|
          elements << Aperm[perm.map{ |i| [i,perm[i-1]] }]
        end
        return elements.sort!{ |a,b| a.rank <=> b.rank }
      when "B"
        new_elements = Array.new
        (1..n).map{ |i| i }.permutation(n).map{ |perm| perm }.each do |perm|
          elements << Bperm[perm.map{ |i| [i,perm[i-1]] }]
        end
        elements.each do |x|
          0.upto(n) do |k|
            (1..n).to_a.combination(k).to_a.each do |subset|
              element = x.dup
              1.upto(n) do |i|
                element[i] = -element[i] if subset.include?(i)
              end
              new_elements << element
            end
          end
        end
        return (elements|new_elements).sort!{ |a,b| a.rank <=> b.rank }
      when "D"
        new_elements = Array.new
        (1..n).map{ |i| i }.permutation(n).map{ |perm| perm }.each do |perm|
          elements << Bperm[perm.map{ |i| [i,perm[i-1]] }]
        end
        elements.each do |x|
          0.upto((n/2).floor) do |k|
            (1..n).to_a.combination(2*k).to_a.each do |subset|
              new_element = x.dup
              1.upto(n) do |i|
                new_element[i] = -new_element[i] if subset.include?(i)
              end
              new_elements << new_element
            end
          end
        end
        return (elements|new_elements).sort!{ |a,b| a.rank <=> b.rank }
      when "I"
        new_element = identity
        rotation = Aperm[new_element.keys.map{ |i| [i,new_element[i%n+1]] }]
        1.upto(n) do |i|
          elements << new_element = product(new_element,rotation)
          elements << Aperm[new_element.map{|key,value| [key,n - value + 1]}]
        end
        return (elements.uniq).sort!{ |a,b| a.rank <=> b.rank }
    end
  end
  
  # returns the identity element of the group
  def identity
    case type
      when "A"
        return Aperm[(1..n+1).map{ |i| [i,i] }]        
      when "B"
        return Bperm[(1..n).map{ |i| [i,i] }]        
      when "D"
        return Bperm[(1..n).map{ |i| [i,i] }]        
      when "I"
        return Aperm[(1..n).map{ |i| [i,i] }]        
    end
  end
  
  # returns the transposition (i,i+1) for type A; returns (1,i) for i > 0 and (1,-1) for i = 0 for type B
  def s(i)
    return nil if i < 0
    case type
      when "A"
        return t(i,i+1)
      when "B"
        case
          when i > 0
            return t(1,i)
          when i == 0
            gen = identity
            gen[1] = -1
            return gen
        end
      when "D"
        case
          when i > 0
            return t(1,i)
          when i == 0
            return t(1,-2)
        end
    end
  end
  
  # returns the transposition (i,j) as a group element
  def t(i,j)
    t = identity
    if j < 0
      t[i], t[-j] = t[j], t[-i]
    else
      t[i], t[j] = t[j], t[i]
    end
    return t
  end
  
  # returns the cartan matrix of the group
  def coxeterMatrix
    g = generators.size
    c = Matrix.identity(g)
    1.upto(g) do |i|
      i.upto(g) do |j|
        m = 1
#        puts "( #{generators[i-1].compact} , #{generators[j-1].compact} )"
        prod = product(generators[i-1],generators[j-1])
#        puts "    1 - "+prod.compact
        until prod == identity
          m += 1
          prod = product(generators[i-1],generators[j-1],prod)
#          puts "    #{m} - #{prod.compact}"
        end
        c[i-1,j-1] = m
        c[j-1,i-1] = m
      end
    end
    return c
  end
  
  # generates array of involutions
  def involutions
    involutions = Array.new
    elements.each do |x|
      involutions << x if product(x,x) == identity
    end
    return involutions
  end
  
  # generates array of the fixed-point-free involutions
  def fixedPointFreeInvolutions
    fixedPointFreeInvs = Array.new
    involutions.each do |x|
      fixedPointFreeInvs << x if x.isFixedPointFree? 
    end
    return fixedPointFreeInvs
  end
  
  # outputs details of group
  def print_summary
    puts
    puts "_"*(50)
    print "\n  Coxeter group: "
    case type
      when "B"
        print "BC_#{n}"
      when "I"
        print "#{type}_2(#{n})"
      else
        print "#{type}_#{n}"
    end
    puts "            Order: #{elements.size}\n"
    puts "_"*(50),"\n"
    puts "  Generators (#{generators.size}):" + generators.map{ |gen| " #{gen.compact}"}.join(",")
    puts "\n  Coxeter Matrix:"
    puts coxeterMatrix.nice("\t")
    puts "\n  Reflections (#{reflections.size}):" + reflections.map{ |t| " #{t.compact}" }.join(",")
    puts "\n  Elements (#{elements.size}):"
    puts elements.map{ |x| "(#{x.rank})".rjust(8) + " #{x.compact}" }
    puts "\n  Involutions (#{involutions.size}):"
    puts involutions.map{ |x| "(#{x.rank})".rjust(8) + " #{x.compact}" }
    puts "\n  Fixed-point-free Involutions (#{fixedPointFreeInvolutions.size}):"
    puts fixedPointFreeInvolutions.map{ |x| "(#{x.rank})".rjust(8) + " #{x.compact}" }
    puts "_"*(50)
  end
  
  # returns the product of two permutations
  def multiply(x,y)
    if x.size == y.size
      xy = identity
      identity.each_key.map { |i| xy[i] = x[y[i]] }
      return xy
    else 
      return nil
    end  
  end
  
  # returns the product of two or more permutations
  def product(x,*ys)
    xys = x
    0.upto(ys.size - 1) do |i|
      xys = multiply(xys,ys[i])
    end
    return xys
  end
  
  #returns the group elements covering x under strong Bruhat order
  def right_ascents(x)
    ascents = Array.new
#    x.rises.each do |rise|
#      ascents << t(rise[0],rise[1])
#    end
    reflections.each do |t|
      ascents << t if product(x,t).rank > x.rank
    end
    return ascents
  end
end
#################################################
############## BRUHAT GRAPH #####################
#################################################
class BruhatGraph
  attr_accessor :group, :nodes, :edges
  
  def initialize(group, order='strong')
    # generate nodes from CoxeterGroup.elements
    @group = group
    @nodes = group.elements
    
    # generate edges from CoxeterGroup.cover_relations
    @edges = Hash.new
    group.elements.each do |x|
      x_covers =  Array.new
      group.right_ascents(x).each do |t|
        x_covers << group.product(x,t)
      end
      x_covers.delete_if { |y| y.rank != x.rank + 1 }
      # work out transitive closure later -- in time, not in the program
      @edges[x] = x_covers
    end
  end
  
  # returns array of hashes, each of which looks like {element => [x1, x2, ..., xk]} 
  # and represents edges from element
  def cover_relations(group,x)
    
  end
  
  
  # creates dot file of hasse diagram of the bruhat graph
  def make_dot_file(filename)
	  dot_file_contents = String.new
	  dot_file_contents << "digraph G {\n\n"
	  dot_file_contents << "\tmincross = 1.0;\n"
	  dot_file_contents << "\tnode [shape = plaintext, height = .1, width = .1, fontsize = 8];\n"
	  dot_file_contents << "\tedge [arrowhead = none, labelfontsize = 6];\n"
	  dot_file_contents << "\n"
    
	  nodes.each do |x|
	    dot_file_contents << "\t\"#{x.compact}\" [fontcolor=red];\n" if group.fixedPointFreeInvolutions.include?(x)
	  end
	  dot_file_contents << "\n"
	  
	  edges.each do |node,covers|
	    covers.each do |cover|
        dot_file_contents << "\t\"#{cover.compact}\" -> \"#{node.compact}\";\n"
	    end
	  end
	  dot_file_contents << "}"
	  #save dot file
	  file = File.open("#{filename}.dot","w") do |f1|
	    f1.puts dot_file_contents
	  end
	  command = "echo \'#{dot_file_contents}\' | dot -Tpng -o #{filename}.png"
	  system(command)
  end
  
  def successors(x)
    neighbor_set = Array.new
    x.right_ascent_set.each do |t|
      neighbor_set << product(x,t)
    end    
    return neighbor_set
  end
  
  def filter(x)
    filter = successors(x).push(x)
    successors(x).each do |y|
      filter = filter | filter(y)
    end
    return filter.uniq
  end
  
  def predecessors(x)
    predecessor_set = Array.new
    x.right_descent_set.each do |t|
      predecessor_set << product(x,t)
    end    
    return predecessor_set
  end
  
  def ideal(x)
    ideal = predecessors(x).push(x)
    predecessors(x).each do |y|
      ideal = ideal | ideal(y)
    end
    return ideal.uniq
  end
  
  def transitive_closure
    
  end
end
