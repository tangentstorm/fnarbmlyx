# this helper is so the  rectangle for dragging the selected
# objects is behind the selection resizer handles.
# !! I'm not sure I needed to do this, but it's working. :/
extends GsBase
func get_class_name(): return "GsDragHelper"

func _ready():
	self.draggable = true

func _drag_step(dxy):
	get_parent()._drag_step(dxy)
