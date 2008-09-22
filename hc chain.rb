require "compoundparser.rb"
require "element.rb"
require "periodictable.rb"
require "lewis.rb"
require "render.rb"

#compound = gets.chomp.split("")
#elements = parse(compound).flatten # disregards polyatomic ions with flatten
#charge = elements.pop.to_i

c1 = Element.new("C", nil)
c2 = Element.new("C", c1)
c3 = Element.new("C", c2)
c4 = Element.new("C", c3)

c1.next = c2
c1.next = Element.new("H", c1)
c1.next = Element.new("H", c1)
c1.next = Element.new("H", c1)

c2.next = c3
c2.next = Element.new("H", c2)
c2.next = Element.new("H", c2)

c3.next = c4
c3.next = Element.new("H", c3)
c3.next = Element.new("H", c3)

c4.next = Element.new("H", c4)
c4.next = Element.new("H", c4)
c4.next = Element.new("H", c4)

fix(c1, 0)

render(c1)
