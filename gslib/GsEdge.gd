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

func _clone()->Node:
	var c = .duplicate(0)
	for slot in get_property_list():
		var k = slot['name']
		if not k in ['src', 'dst', 'src_path', 'dst_path']:
			c.set(k, get(k))
	return c

func _set_src_path(v):
	src_path = v
	if is_inside_tree():
		src = null if v == '' else get_node(v)

func _set_dst_path(v):
	dst_path = v
	if is_inside_tree():
		dst = null if v == '' else get_node(v)

func _set_src(v):
	src = v
	src_path = '' if v == null else v.get_path()

func _set_dst(v):
	dst = v
	dst_path = '' if v == null else v.get_path()

func _on_node_moved():
	var a = src.link_point(0)
	var b = dst.link_point(0) - a
	curve.set_point_position(1, b)
	self.start = a

func _drag_step(_dxy):
	update()
