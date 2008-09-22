require 'cgi'

cgi = CGI.new

puts `echo #{cgi['molecule']} | ruby main.rb`

puts "<HTML>"
puts "<IMG src=\"lewis.png\"></IMG>"
puts "<P>"
puts "#{cgi['molecule']}"
puts "<P>"
puts "If the image isn't for the desired molecule, an error occured most likely."
puts "</HTML>"
