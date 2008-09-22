#!/usr/bin/env ruby
require 'RMagick'
include Magick

=begin
This file was written:
From scratch
Between the hours of 8 PM and 2 AM from Sunday June 10th to Monday June 11th
With GEdit
By:
  ____    _    __  __        _____ _____ _   _ _   ___   __
 / ___|  / \  |  \/  |      |_   _| ____| \ | | \ | \ \ / /
| |     / _ \ | |\/| |        | | |  _| |  \| |  \| |\ V / 
| |___ / ___ \| |  | |        | | | |___| |\  | |\  | | |  
 \____/_/   \_\_|  |_|        |_| |_____|_| \_|_| \_| |_|  

SO DON'T YOU BE MESSIN' WITH IT!!!1!! NOOBZORZ!

=end

#HAH globalz
$LEFT = 0
$RIGHT = 1
$DOWN = 2
$UP = 3

$DISTANCE = 40
$FONTSIZE = 20

#Returns the maxixmum depth of the lewis structure.
#Used for determining image size.
def depth(tree)
	if !tree.nodes?
		return 1
	else
		ld = []#List of depths
		x = 0
		tree.nodes.delete(tree.parent) if (tree.nodes.length != 4)
		tree.nodes.each do |node|
			ld[x] = depth(node) if node
		end
		return 1 + max(ld) if max(ld)
	end
	return 1
end

#Max val in an array
def max(arr)
	m = arr[0] if arr[0]
	arr.each do |x| m = x if x > m end
	m
end

#Transform coord[x, y] based on direction.
def transform(coord, direction, dist)
	newcoord = coord.clone
	case direction
		when $LEFT
			newcoord[0] -= dist
		when $RIGHT
			newcoord[0] += dist
		when $DOWN
			newcoord[1] += dist #Inverted y-axis
		when $UP
			newcoord[1] -= dist #See previous comment (lawl too lazy to type so i type a long explanation)
	end
	newcoord
end

#Are the directions opposite?
def oppdirs?(dira, dirb)
	return true if (dira == $UP && dirb == $DOWN)
	return true if (dira == $DOWN && dirb == $UP)
	return true if (dira == $LEFT && dirb == $RIGHT)
	return true if (dira == $RIGHT && dirb == $LEFT)
	return false
end

def op(dir)
	return $UP if dir == $DOWN
	return $DOWN if dir == $UP
	return $LEFT if dir == $RIGHT
	return $RIGHT if dir == $LEFT
	return 4
end

#Number of copies of subnode in list of nodes
def numcopies(subnode, nodes)
	copies = 0
	nodes.each do |x|
		copies += 1 if x == subnode
	end
	copies
end	

#DRAWS A BOND, YO
#Vert actually means horizontal.  I messed up and instead of changing lines, I just put in a "!"
def drawbond(coordA, coordB, bleness, vert)
	if !vert
		ca = transform(coordA, $LEFT, bleness * 3)
		cb = transform(coordB, $LEFT, bleness * 3)
	else
		ca = transform(coordA, $UP, bleness * 3)
		cb = transform(coordB, $UP, bleness * 3)
	end
	
	(1..bleness).each do |ble|
		if !vert
			$canvas.line(ca[0] + (ble * 3), ca[1], cb[0] + (ble * 3), cb[1])
		else
			$canvas.line(ca[0], ca[1] + (ble * 3), cb[0], cb[1] + (ble * 3))
		end
	end
end

#HARGH NOOBZKAKE
def dot(x, y)
	(-1..1).each do |t|
		$canvas.line(x - 1, y + t, x + 1, y + t)
	end
end

#Draws a pair of non-bonding electrons on str at coords in direction.
#I'm tired, so no nice-var-names
def drawepair(strlen, coord, dir)
	if (strlen == 1)
		blah = transform(coord, dir, 1)
	elsif (dir == $UP || dir == $DOWN)
		blah = transform(coord, dir, 1)
	else blah = transform(coord, dir, strlen * 3)
	end
	if (dir == $UP || dir == $DOWN)
		dot(blah[0] + 3, blah[1])
		dot(blah[0] - 3, blah[1])
	else
		dot(blah[0], blah[1] + 3)
		dot(blah[0], blah[1] - 3)
	end
end

#Removes duplicate elements from nodelist, but keeps in all nil pairs.
def uniqelms(nodelist)
	numnils = nodelist.length - nodelist.compact.length
	newlist = nodelist.uniq
	(numnils - 1).times do newlist.push(nil) end
	newlist
end

#Draws tree with REKURZN DOODS ZOMGHAXFISH
def drawtree(node, coordfrom, dirfrom, parent)
	if (node) #Node exists, not nil
		curcoord = transform(coordfrom, dirfrom, $DISTANCE)
		strlen = node.element.length
		$canvas.text(curcoord[0] - (strlen * $FONTSIZE / 3), curcoord[1] + ($FONTSIZE / 3), node.element)
		if node.nodes? #Stupid line.  If there are nodes to render...
			curdir = $LEFT
			uniqelms(node.nodes).each do |subnode|
				curdir += 1 if (oppdirs?(curdir, dirfrom))
				drawtree(subnode, curcoord, curdir, node)
				drawbond(transform(curcoord, curdir, ($FONTSIZE / 2)), transform(curcoord, curdir, $DISTANCE - ($FONTSIZE / 2)), numcopies(subnode, node.nodes), !(curdir == $UP || curdir == $DOWN)) if subnode #If subnode is not nil.  Nil is handled in the previous line by recursion. LOONG LINE RIGHT HERE OH YEAH BABY WOOO!
				curdir += 1
			end
		end
	else #Node is nil! Easy easy peezy schmeezy deezy fleezy part.
		curcoord = transform(coordfrom, dirfrom, ($FONTSIZE / 3) + 3)
		drawepair(parent.element.length, curcoord, dirfrom)
	end
end

#Tedious main handler method.
def render(root)
	$dimension = depth(root) * ($DISTANCE + $FONTSIZE) #arbitrary! yay!
	
	#image junkiness
	$img = Magick::Image.new($dimension, $dimension) { self.background_color = 'white' }
	$canvas = Magick::Draw.new
	$canvas.font_family "Courier" #Monospace
	$canvas.pointsize $FONTSIZE #14-pt font
	$canvas.font_weight 600
	$canvas.stroke_width 2
	#$canvas.gravity Magick::CenterGravity
	
	#hardcore algz
	drawtree(root, [($dimension / 2).to_i,($dimension / 2).to_i], 4, root)
	#$canvas.text(0, 0, "HI")
	
	#more graphical library junkiness
	$canvas.draw($img)
	$img.resize!(120, 120, Magick::GaussianFilter, 1)
	#$img.display
	$img.write("lewis.png")
end
=begin
wait for it...
it's coming...
watch out...
here it comes...
(look down)
=end
#ZOMGHAX 200 LINES
