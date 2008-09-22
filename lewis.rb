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

# counts valence electrons
def valencecount(elements, charge)
	valencecount = 0
	elements.each { |element|
		valencecount += PeriodicTable.valence(element)
	}
	
	valencecount += charge
	return valencecount
end

# function that fixes bonds in the structure
def fix(node, charge)
	# if this node has any children, fix them
	if node.next?
		# only fix the children that are elements
		node.nodes.compact.each { |n|
			charge = fix(n, charge)
		}
	end
	# if this element is not the root, and the formal charge has still not been met for both the current element and the parent, make a bond between the current element and its parent
	if node.formal_charge != 0
		if charge != 0
			charge -= node.formal_charge
		else
			while node.formal_charge != 0
				if !node.root? && !node.parent.full?
					node.next = node.parent
					node.parent.next = node
				else
					charge -= node.formal_charge
					break
				end
			end
		end
	end
	return charge
end

def fixvalence(node, vcount)
	valenceelectrons = 0
	if node.nodes?
		node.nodes.each { |n|
			if n == nil
				valenceelectrons += 2
			else
				valenceelectrons += 2 + fixvalence(n, vcount)
			end
		}
	end
	if !node.root?
		return valenceelectrons
	else
		if vcount > valenceelectrons
			((vcount - valenceelectrons) / 2).times {
				node.next = nil
			}
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
	
	valencecount = valencecount(elements, charge)
	
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
			fixvalence(root, valencecount)
			charge = fix(root, charge)
			if charge != 0
				puts "Sorry, Lewis Structure could not be created"
				return
			end
		# if there are 2 elements in the compound, take the least electronegative and make it the central atom
		# attach all other elements onto the central atom
		when 2
			root = cur = Element.new(elements.shift, nil)
			while !elements.empty?
				cur.next = Element.new(elements.shift, cur)
			end
			fixvalence(root, valencecount)
			charge = fix(root, charge)
			if charge != 0
				puts "Sorry, Lewis Structure could not be created"
				return
			end
	end
	return root
end
