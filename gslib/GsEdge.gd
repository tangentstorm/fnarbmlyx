# This is a curve whose endpoints may be tied to GsNodes.
# The nodes themselves keep track of the event handling
# for all connected edges, but the edges need to remember
# which side is which.
class_name GsEdge extends GsCurve
func get_class_name(): return 'GsEdge'

export var src_path : NodePath setget _set_src_path
export var dst_path : NodePath setget _set_dst_path

onready var src = null if src_path == '' else get_node(src_path) setget _set_src
onready var dst = null if dst_path == '' else get_node(dst_path) setget _set_dst

func _set_src_path(v):
	src_path = v
	if v != '': src = get_node(v)

func _set_dst_path(v):
	dst_path = v;
	if v != '': dst = get_node(v)

func _set_src(v):
	src = v
	if v != null: src_path = v.get_path()

func _set_dst(v):
	dst = v
	if v != null: dst_path = v.get_path()

func _on_node_moved():
	var a = src.link_point(0)
	var b = dst.link_point(0) - a
	rect_position = a
	curve.set_point_position(1, b)
	update()
