=begin
this class represents an element in a lewis structure
it can be also thought of as a node in a tree
bonds are synonymous with nodes (child nodes to be specific)

the root node has 4 bonding sites by default (can be changed if it can expand its octet)
every other element* has 3 bonding sites (because if it isnt the root, it is bonded to another element already (stored in parent)

*EXCEPTION:
if hydrogen is the root node, it has 1 bonding site (so far, the only compound where this is applicable is H2)
otherwise, hydrogen doesnt have any bonding sites, just a parent
so its nodes array is nil

the elements that a given element bonds too are stored in the array nodes
the parent of a given element is stored in parent; the root node has a nil parent

num is only used for debugging purposes as an identification number, such as testing double and triple bonds (making sure that the same element is bonding, and not a different one)

=end

class Element
	attr_accessor :element, :nodes, :parent, :num	

	@@num = 1
	
	def initialize(element = nil, parent = nil)
		@num = @@num
		@@num += 1
		@element = element
		@parent = parent
		# handles how many nodes a given element is supposed to have
		case element
			when "H"
				sites = 0
			when "B"
				sites = 2
			else
				sites = 3
		end
		if root?
			sites += 1
		end
		if sites == 0
			@nodes = nil
		else
			@nodes = Array.new(sites)
		end
	end
	
	# returns true if this element is hydrogen
	def h?
		return element == "H"
	end	
	
	# returns true if it is the root node
	def root?
		return parent == nil
	end
	
	# returns true if element has nodes
	def nodes?
		return !h? || (h? && root?)
	end
	
	# calculates formal charge (method used to determine structure generation)
	def formal_charge
		if root?
			lewis_electrons = 0
		else #if an element is not the root, it is bonded to another element, thus increase the formal charge count by 1
			lewis_electrons = 1
		end
		# if the element has nodes, look at each one
		if nodes?
			nodes.each { |node|
				if node == nil # if the node is unbonded, add 2
					lewis_electrons += 2
				else # if it is bonded, add 1
					lewis_electrons += 1
				end
			}
		end
		# return the valence count - the lewis count (definition of formal charge)
		return PeriodicTable.valence(element) - lewis_electrons
	end
	
	# return true if the element has a full octet, or more, or if it has 2 valence electrons if its a hydrogen
	def full?
		if nodes?
			nodes.each { |node|
				if node == nil
					return false
				end
			}
		end
		
		return true
	end
	
	# returns true if the element can expand its octet (bond to more elements)
	def expands?
		return PeriodicTable.atomic_number(element) > 13
	end
	
	# Bad Method, DO NOT USE
	# i fear that this method might return the same node each call, even though my intent is for it to return the _next_ node
	# could probably be fixed with shifting the returned element to the end of the array
=begin
	def next
		if nodes?
			nodes.each_index { |i|
				if nodes[i] != nil
					# possible fix? (untested)
					node = nodes.at(i)
					nodes.push node
					nodes.delete_at(i)					
					return node
				end
			}
		end
		return nil
	end
=end
	
	# if something is bonded to this element (excludes parent), return true
	def next?
		if nodes?
			if nodes.compact.length > 0 # if nodes is full of nil, this returns 0, otherwise the length is positive, and something is bonded to the element
				return true
			end
		end
		return false
	end

	# sets the next unbonded node in nodes to node
	def next=(node)
		# you can only bond if it has unbonded sites
		if !full?
			nodes.each_index { |i|
				if nodes.at(i) == nil
					nodes[i] = node
					break
				end
			}
			return node
		# unless it expands, in which case you can bond
		elsif expands?
				nodes << node
				puts nodes
				nodes.flatten!
				return node
		# cannot further bond
		else
			return nil
		end
	end		
	
	def to_s
		"#{element} #{num}"
	end
end
