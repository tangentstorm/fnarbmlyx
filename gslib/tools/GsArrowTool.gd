extends GsMouseTool
func get_class_name(): return "GsArrowTool"

func _drag_start(mouse):
	if mouse.subject == null:
		mouse.selectangle.visible = true
	_drag_step(mouse)

func _drag_step(mouse):
	if mouse.subject:
		print("dragging subject:", mouse.subject)
		mouse.subject._drag_step(mouse.position + mouse.offset, self)
	else:
		var r : Rect2 = mouse.drag_rect().abs()
		mouse.selectangle.rect_position = r.position
		mouse.selectangle.rect_size = r.size

func _drag_end(mouse):
	if mouse.subject: mouse.subject._drag_end()
	else: mouse.selectangle.visible = false
