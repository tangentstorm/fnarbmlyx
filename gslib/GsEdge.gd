# This is a curve whose endpoints may be tied to GsNodes.
# The nodes themselves keep track of the event handling
# for all connected edges, but the edges need to remember
# which side is which.
class_name GsEdge extends GsCurve
func get_class_name(): return 'GsEdge'

export var src_path : NodePath setget _set_src_path
export var dst_path : NodePath setget _set_dst_path

var src = null setget _set_src
var dst = null setget _set_dst

func _set_src_path(v):
	src_path = v; src = get_node(v)

func _set_dst_path(v):
	dst_path = v; dst = get_node(v)

func _set_src(v):
	src = v
	if v: src_path = v.get_path()

func _set_dst(v):
	dst = v
	if v: dst_path = v.get_path()

func _on_node_moved(node:GsNode, dxy:Vector2):
	var p = curve.get_point_position(1)
	if node == src:
		rect_position += dxy
		curve.set_point_position(1, p - dxy)
	if node == dst:  # could be both src and dst!
		curve.set_point_position(1, p + dxy)
	update()
