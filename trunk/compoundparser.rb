# functions pertaining to parsing a compound (string) into the elements that make it up (array), with subarrays if there are polyatomic ions

# returns true if the character char is a number between 0 and 9
def isnum(char)
	return char[0] >= 48 && char[0] <= 57
end

# the parsing function, also recursively called when () are encountered in the compound
def parse(compound)
	subcompound = false # subcompound dictates whether a subcompound is being parsed: part between ()
	chargemod = false
	charge = Array.new
	modifier = "" # string to hold a number after elements or polyatomic ions encapsulated between (), because characters are parsed one by one, thus making it difficult if you are counting more than 9 of an element/polyatomic ion
	element = ""
	elements = Array.new
	compound.each { |char|
		# handles charges at the end of some compounds/polyatomic ions (begins charge)
		if char == "^"
			chargemod = true
			next
		end
		if chargemod
			charge << char
			next
		end
		# subcompound has ended, thus parse it so it can be included in the array of elements
		if char == ")"
			element = parse(element.split(""))
			subcompound = false
			next
		end
		# if subcompound mode is active, stores characters in the subcompound 
		if subcompound
			element << char
			next
		end
		# engages subcompound mode, as well as cleans up what may have been left to parse (element and its modifier)
		if char == "("
			subcompound = true
			if (element != "")
				if (modifier.to_i > 0)
					(modifier.to_i - 1).times {
						elements << element
					}
					modifier = ""
				end
			elements << element
			element = ""
			end
			next
		end
		# if character is a number, add it to the modifer
		if (isnum(char))
			modifier << char
			next
		end
		# if the character is uppercase, a new element has begun, so store the previous element in the array of elements times the modifier if there is one, and begin a new element
		if char.upcase == char && element != ""
			if (modifier.to_i > 0)
				(modifier.to_i - 1).times {
					elements << element
				}
				modifier = ""
			end
			elements << element
			element = ""
		end
		element << char
	}
	# clean up any unparsed modifier, charge or element
	if (modifier.to_i > 0)
		(modifier.to_i - 1).times {
			elements << element
		}
		modifier = ""
	end
	elements << element
	element = ""
	if chargemod
		positivenegative = ""
		if charge.length == 1
			charge << "1"
			charge.flatten!
		end
		charge.each { |char|
			if isnum(char)
				modifier << char
			else 
				positivenegative = char
			end
		}
		elements << modifier.split("").unshift(positivenegative).flatten.join
	else
		elements << "0"
	end
	return elements
end
