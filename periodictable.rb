# this class is a collection of methods and data pertaining to the periodic table

class PeriodicTable
	attr_accessor :element_list
	
	# Hash of the periodic table, with the element as the key and the atomic number as the value
	@@element_list = { "H" => 1, "He" => 2, "Li" => 3, "Be" => 4, "B" => 5, "C" => 6, "N" => 7, "O" => 8, "F" => 9, "Ne" => 10, "Na" => 11, "Mg" => 12, "Al" => 13, "Si" => 14, "P" => 15, "S" => 16, "Cl" => 17, "Ar" => 18, "K" => 19, "Ca" => 20, "Sc" => 21, "Ti" => 22, "V" => 23, "Cr" => 24, "Mn" => 25, "Fe" => 26, "Co" => 27, "Ni" => 28, "Cu" => 29, "Zn" => 30, "Ga" => 31, "Ge" => 32, "As" => 33, "Se" => 34, "Br" => 35, "Kr" => 36, "Rb" => 37, "Sr" => 38, "Y" => 39, "Zr" => 40, "Nb" => 41, "Mo" => 42, "Tc" => 43, "Ru" => 44, "Rh" => 45, "Pd" => 46, "Ag" => 47, "Cd" => 48, "In" => 49, "Sn" => 50, "Sb" => 51, "Te" => 52, "I" => 53, "Xe" => 54, "Cs" => 55, "Ba" => 56, "La" => 57, "Ce" => 58, "Pr" => 59, "Nd" => 60, "Pm" => 61, "Sm" => 62, "Eu" => 63, "Gd" => 64, "Tb" => 65, "Dy" => 66, "Ho" => 67, "Er" => 68, "Tm" => 69, "Yb" => 70, "Lu" => 71, "Hf" => 72, "Ta" => 73, "W" => 74, "Re" => 75, "Os" => 76, "Ir" => 77, "Pt" => 78, "Au" => 79, "Hg" => 80, "Tl" => 81, "Pb" => 82, "Bi" => 83, "Po" => 84, "At" => 85, "Rn" => 86, "Fr" => 87, "Ra" => 88, "Ac" => 89, "Th" => 90, "Pa" => 91, "U" => 92, "Np" => 93, "Pu" => 94, "Am" => 95, "Cm" => 96, "Bk" => 97, "Cf" => 98, "Es" => 99, "Fm" => 100, "Md" => 101, "No" => 102, "Lr" => 103, "Rf" => 104, "Db" => 105, "Sg" => 106, "Bh" => 107, "Hs" => 108, "Mt" => 109 }

	# given an element, it returns the elements atomic number
	def PeriodicTable.atomic_number(element)
		return @@element_list[element]
	end
	
	# given an element, it returns the number of valence electrons
	# this is based on ranges of atomic numbers
	def PeriodicTable.valence(element)
		anum = atomic_number(element)
		# if the element is in the first family
		if anum <= 2
			val = anum % 2
		# if the element is in the 2nd or 3rd family
		elsif anum >= 3 && anum <= 18
			val = (anum - 2) % 8
		# if the element is in the 4th or 5th family (has d shells)
		elsif anum >= 19 && anum <= 54
			# if in family 5, "make" into family 4
			tempanum = anum - 18
			if tempanum >= 19
				tempanum -= 18
			end
			# alkali metal
			if tempanum == 1
				val = 1
			# alkaline earth or transition element
			elsif tempanum >= 2 && tempanum <= 12
				val = 2
			# boron column to noble gas
			else
				val = tempanum - 10
			end
		# if it is in the 6th or 7th family (has f shells)
		elsif anum >= 55 && anum <= 109
			# if in family 7, "make into family 6
			tempanum = anum - 54
			if tempanum >= 33
				tempanum -= 32
			end
			# alkali metal
			if tempanum == 1
				val = 1
			# alkaline earth or transition element or rare earth metal
			elsif tempanum >= 2 && tempanum <= 26
				val = 2
			# boron column to noble gas
			else
				val = tempanum - 24
			end
		end
		# if it is a noble gas, return 8 valence electrons
		if val == 0
			val = 8
		end
		return val
	end
end
