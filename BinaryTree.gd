class_name BinaryTree
tool extends Control

var colors = Palettes.colors_category10

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
	build_node(rect_size * 0.5, DEPTH)
