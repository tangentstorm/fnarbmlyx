class_name GsHandle extends GsBase
func get_class_name(): return "GsHandle"

func _ready():
	self.draggable = true

func _dxy(dxy):
	get_parent().rect_position += dxy
	if GsLib.app.selection.size() == 1:
		GsLib.app.selection[0].rect_position += dxy

func _dwh(dwh):
	get_parent().rect_size += dwh
	if GsLib.app.selection.size() == 1:
		GsLib.app.selection[0].rect_size += dwh

func _drag_step(dxy):
	# dragging a handle resizes the control, leaving
	# the other handles in place globally. This means
	# handles on the bottom/right (south/east) can
	# simply resize the selection, but handles on the
	# top/left (north/west) have to change the position
	# of the selection box, and then resize in the
	# opposite direction to compensate.
	# Since the handle is a child of the selection, we
	# have to tell the mouse to update our offset.
	var m = _get_mouse()
	var p = get_parent()
	var name = get_name()
	if name.begins_with('N'):
		m.offset.y -= dxy.y
		_dxy(dxy.y * Vector2.DOWN)
		_dwh(dxy.y * Vector2.UP)
	elif name.begins_with('S'):
		_dwh(dxy.y * Vector2.DOWN)
	if name.ends_with('W'):
		m.offset.x -= dxy.x
		_dxy(dxy.x * Vector2.RIGHT)
		_dwh(dxy.x * Vector2.LEFT)
	elif name.ends_with('E'):
		_dwh(dxy.x * Vector2.RIGHT)
