class_name BinaryTree
tool extends Control

# dawnbringer palette https://pixeljoint.com/forum/forum_posts.asp?TID=12795
var colors_dawnbringer = [
  Color(0x140c1cff), Color(0x442434ff), Color(0x30346dff), Color(0x4e4a4eff),
  Color(0x854c30ff), Color(0x346524ff), Color(0xd04648ff), Color(0x757161ff),
  Color(0x597dceff), Color(0xd27d2cff), Color(0x8595a1ff), Color(0x6daa2cff),
  Color(0xd2aa99ff), Color(0x6dc2caff), Color(0xdad45eff), Color(0xdeeed6ff)]

# https://github.com/d3/d3-3.x-api-reference/blob/master/Ordinal-Scales.md
var colors_category10  = [  # d3 category10
  Color(0x1f77b4ff), Color(0xff7f0eff), Color(0x2ca02cff),  Color(0xd62728ff),
  Color(0x9467bdff), Color(0x8c564bff), Color(0xe377c2ff),  Color(0x7f7f7fff),
  Color(0xbcbd22ff), Color(0x17becfff)]

var colors = colors_category10

var node_radius = 16
var gap = 2
var DEPTH = 5

func build_node(xy, depth):
	var width = (node_radius + gap) * (1<<depth)
	if depth:
		var dx = width /2
		var dy = 40
		var lxy = xy + Vector2(+dx, dy)
		var rxy = xy + Vector2(-dx, dy)
		draw_line(xy, lxy, Color.black, 1, true)
		draw_line(xy, rxy, Color.black, 1, true)
		build_node(lxy, depth-1)
		build_node(rxy, depth-1)
	draw_circle(xy, node_radius, Color.black)
	draw_circle(xy, node_radius-1.5, colors[DEPTH-depth])

func _draw():
	var width = (node_radius + gap) * (2<<DEPTH)
	build_node(rect_size * 0.5, DEPTH)
