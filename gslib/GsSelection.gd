tool extends GsBase
func get_class_name(): return "GsSelection"

func _ready():
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
		if c.get_name() == 'drag_helper': continue
		c.rect_position -= c.rect_size/2

func _drag_step(dxy):
	rect_position += dxy
	for c in GsLib.app.selection:
		if c == self: continue # just in case
		c._drag_step(dxy)
