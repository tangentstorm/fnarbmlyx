# This is a curve whose endpoints may be tied to GsNodes.
# The nodes themselves keep track of the event handling
# for all connected edges, but the edges need to remember
# which side is which.
@tool class_name GsEdge extends GsCurve
func get_class_name(): return 'GsEdge'

var _src_path : NodePath
@export var src_path : NodePath:
	get:
		return _src_path
	set(v):
		_src_path = v
		if is_inside_tree():
			_src = null if v == null else get_node(v)
	
var _dst_path: NodePath
@export var dst_path : NodePath:
	get:
		return _dst_path
	set(v):
		_dst_path = v
		if is_inside_tree():
			_dst = null if v == null else get_node(v)

var _src : GsNode
@onready var src = null if src_path == null else get_node(src_path):
	get:
		return _src
	set(v):
		_src = v
		_src_path = '' if v == null else v.get_path()

var _dst : GsNode
@onready var dst = null if dst_path == null else get_node(dst_path):
	get:
		return _dst
	set(v):
		_dst = v
		_dst_path = '' if v == null else v.get_path()



func _clone()->Node:
	var c = super.duplicate(0)
	for slot in get_property_list():
		var k = slot['name']
		if not k in ['src', 'dst', 'src_path', 'dst_path']:
			c.set(k, get(k))
	return c



func _on_node_moved():
	var a = src.link_point(0)
	var b = dst.link_point(0) - a
	curve.set_point_position(1, b)
	self.start = a

func _drag_step(_dxy):
	queue_redraw()
