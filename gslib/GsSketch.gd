class_name GsSketch extends Control

var edges
var nodes

func _ready():
	GsLib.sketch = self

func clear():
	for c in get_children():
		c.queue_free()
