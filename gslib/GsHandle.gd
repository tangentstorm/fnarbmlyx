class_name GsHandle extends GsBase
func get_class_name(): return "GsHandle"

func _ready():
	self.draggable = true


func _drag_step(xy, _mtool):
	# dragging a handle resizes the control, leaving
	# the other handles in place globally. This means
	# handles on the bottom/right (south/east) can
	# simply resize the selection, but handles on the
	# top/left (north/west) have to change the position
	# of the selection box, and then resize in the
	# opposite direction to compensate.
	# Since the handle is a child of the selection, we
	# have to tell the mouse to update our offset.
	var dxy = xy - rect_position
	var m = _get_mouse()
	var p = get_parent()
	var name = get_name()
	if name.begins_with('N'):
		m.offset.y -= dxy.y
		p.rect_position.y += dxy.y
		p.rect_size.y -= dxy.y
	elif name.begins_with('S'):
		p.rect_size.y += dxy.y
	if name.ends_with('W'):
		m.offset.x -= dxy.x
		p.rect_position.x += dxy.x
		p.rect_size.x -= dxy.x
	elif name.ends_with('E'):
		p.rect_size.x += dxy.x
