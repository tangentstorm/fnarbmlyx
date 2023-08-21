tool extends GsBase
func get_class_name(): return "Selectangle"

func _ready():
	connect("resized", Callable(self, "_resized"))
	connect("visibility_changed", Callable(self, '_visibility_changed'))
	connect("item_rect_changed", Callable(self, '_item_rect_changed'))
	_resized()
	
func _resized():
	var w = size.x; var h = size.y
	$NW.position = Vector2(0,0)
	$N.position  = Vector2(w/2,0)
	$NE.position  = Vector2(w,0)
	$E.position = Vector2(w,h/2)
	$SE.position = Vector2(w,h)
	$S.position = Vector2(w/2,h)
	$SW.position = Vector2(0,h)
	$W.position = Vector2(0,h/2)
	for c in get_children():
		c.position -= c.size/2

func _drag_step(dxy):
	position += dxy
	for c in GsLib.app.selection:
		c._drag_step(dxy)

func _click(_xy):
	pass # don't select anything


func _visibility_changed():
	$'../selectangle_helper'.visible = visible

func _item_rect_changed():
	var dh : Control = $'../selectangle_helper'
	dh.position = position
	dh.size = size
