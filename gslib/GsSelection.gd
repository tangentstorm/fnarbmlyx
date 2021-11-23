tool extends GsBase
func get_class_name(): return "GsSelection"

func _ready():
	self.draggable = true
	connect("resized", self, "_resized")
	_resized()
	
func _resized():
	var w = rect_size.x; var h = rect_size.y
	$NW.rect_position = Vector2(0,0)
	$N.rect_position  = Vector2(w/2,0)
	$NE.rect_position  = Vector2(w,0)
	$E.rect_position = Vector2(w,h/2)
	$SE.rect_position = Vector2(w,h)
	$S.rect_position = Vector2(w/2,h)
	$SW.rect_position = Vector2(0,h)
	$W.rect_position = Vector2(0,h/2)
	for c in get_children():
		c.rect_position -= c.rect_size/2

func _drag_step(xy, mtool):
	var dxy = xy - rect_position
	._drag_step(xy, mtool)
	for child in _get_mouse().current_sketch.get_children():
		if not child is GsBase: continue
		if child.selected:
			child.rect_position += dxy
