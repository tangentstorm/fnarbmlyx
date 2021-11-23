class_name GsSketch extends Control

var edges
var nodes

func clear():
	for c in get_children():
		c.queue_free()
