class_name GsEdgeTool extends GsArrowTool
func get_class_name(): return "GsEdgeTool"

var src
var dst

func _click(mouse):
	if mouse.subject: pass
	else:
		src = GsLib.add_rect(mouse.position)
		GsLib.app.selection = [src]

func _drag_start(mouse):
	if mouse.subject: src = mouse.subject
	else: src = GsLib.add_rect(mouse.position)
