# used when displaying hierarchies
def header(level)
	level.times { print ">" }
end

# current method of printing tree
def printlewis(node)
	puts node.to_s + " ="
	if node.nodes?
		temp = Array.new
		node.nodes.each { |n|
			if n == nil
				puts ":"
			elsif n == node.parent
				puts n
			elsif !temp.include?(n)
				temp << n
				puts n
			else
				puts n
			end
		}
		if !temp.empty?
			temp.each { |n|
				puts "========"
				printlewis(n)
			}
		end
	end
end

# old method of print tree (uses header() )
def printnodes(node, level)
	header(level)
	puts node
	if node.nodes?
		temp = Array.new
		node.nodes.each { |n|
			if n == nil
				header(level + 1)
				puts ":"
			elsif n == node.parent
				header(level + 1)
				puts node
			elsif !temp.include?(n)
				temp << n
			else
				header(level + 1)
				puts node
			end
		}
		if !temp.empty?
			temp.each { |n|
				printnodes(n, level + 1)
			}
		end
	end
end

# function that fixes bonds in the structure
def fix(node, charge)
	# if this node has any children, fix them
	if node.next?
		# only fix the children that are elements
		node.nodes.compact.each { |n|
			fix(n, charge)
		}
	end
	# if this element is not the root, and the formal charge has still not been met for both the current element and the parent, make a bond between the current element and its parent
	while !node.root? && node.formal_charge != 0
		if node.parent.next?
			node.next = node.parent
			node.parent.next = node
		end
	end
end

# generates lewis structure, then checks the structure to see if it is correct
def lewis(elements, charge)
	# moves all hydrogens from element array to the end, so the core elements can be dealt with
	hydrogens = Array.new
	elements.delete_if { |element|
		if element == "H"
			hydrogens << "H"
		end
	}
	if !hydrogens.empty?
		elements << hydrogens
	end
	
	elements.flatten!
	
	# depending on how many different elements there are (uniq), the structure is made differently
	lewistype = elements.uniq.length
	
	case lewistype
		# if there is only one element in the compound (ie diatomic, etc)
		# bond each element to each other
		when 1
			root = cur = Element.new(elements.shift, nil)
			while !elements.empty?
				cur = cur.next = Element.new(elements.shift, cur)
			end
			fix(root, charge)
		# if there are 2 elements in the compound, take the least electronegative and make it the central atom
		# attach all other elements onto the central atom
		when 2
			root = cur = Element.new(elements.shift, nil)
			while !elements.empty?
				cur.next = Element.new(elements.shift, cur)
			end
			fix(root, charge)
	end
	
	# prints structure
	printlewis(root)
end
