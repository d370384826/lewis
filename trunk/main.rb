require "compoundparser.rb"
require "element.rb"
require "periodictable.rb"
require "lewis.rb"
require "render.rb"

compound = gets.chomp.split("")
elements = parse(compound).flatten # disregards polyatomic ions with flatten
charge = elements.pop.to_i

render(lewis(elements, charge))
