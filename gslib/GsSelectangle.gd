tool extends GsBase
func get_class_name(): return "Selectangle"

func _ready():
	connect("resized", self, "_resized")
	connect("visibility_changed", self, '_visibility_changed')
	connect("item_rect_changed", self, '_item_rect_changed')
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

func _drag_step(dxy):
	rect_position += dxy
	for c in GsLib.app.selection:
		c._drag_step(dxy)

func _click(_xy):
	pass # don't select anything


func _visibility_changed():
	$'../selectangle_helper'.visible = visible

func _item_rect_changed():
	var dh : Control = $'../selectangle_helper'
	dh.rect_position = rect_position
	dh.rect_size = rect_size
