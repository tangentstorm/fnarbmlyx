# this helper is so the  rectangle for dragging the selected
# objects is behind the selection resizer handles.
# !! I'm not sure I needed to do this, but it's working. :/
class_name GsDragHelper extends GsBase
func get_class_name(): return "GsDragHelper"

export (NodePath) var target_path = '..'

func _drag_step(dxy):
	get_node(target_path)._drag_step(dxy)

func _click(xy):
	get_node(target_path)._click(xy)
