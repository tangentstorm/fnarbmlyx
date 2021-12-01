# this helper is so the  rectangle for dragging the selected
# objects is behind the selection resizer handles.
# !! I'm not sure I needed to do this, but it's working. :/
extends GsBase
func get_class_name(): return "GsSelectionDragHelper"

func _ready():
	self.draggable = true

func _drag_step(dxy):
	get_parent().rect_position += dxy
	for c in GsLib.app.selection:
		if c == self: continue # just in case
		c._drag_step(dxy)
