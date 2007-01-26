periodic_table = {
"H"	=>	1,
"He"	=>	2,
"Li"	=>	3,
"Be"	=>	4,
"B"	=>	5,
"C"	=>	6,
"N"	=>	7,
"O"	=>	8,
"F"	=>	9,
"Ne"	=>	10,
} #	=>	11,
#	=>	12,
#	=>	13
#	=>	
#	=>	
#	=>	
#	=>	
#	=>	
#	=>	

compound = gets.split("").chomp
valencesum = 0

compound.foreach { |element|
	if element.upcase == element || element
		valencesum += periodic_table[atom]
		atom = ""
	end
	
	atom += element
}

puts compound