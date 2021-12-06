class_name GsArrowTool extends GsMouseTool
func get_class_name(): return "GsArrowTool"

func _drag_start(mouse):
	if mouse.subject == null:
		mouse.lasso.visible = true
	_drag_step(mouse)

func _drag_step(mouse):
	if mouse.lasso.visible:
		var r : Rect2 = mouse.drag_rect().abs()
		mouse.lasso.rect_position = r.position
		mouse.lasso.rect_size = r.size
	elif mouse.subject:
		mouse.subject._drag_step(mouse.dxy)

func _drag_end(mouse):
	if mouse.subject: mouse.subject._drag_end()
	else:
		mouse.lasso.visible = false
		var rect = mouse.lasso.get_rect()
		var selection = []

		for c in GsLib.sketch.get_children():
			if not c is GsBase: continue
			var r:Rect2 = c.get_rect()
			if r.intersects(rect):
				c.selected = true
				selection.append(c)
			else: c.selected = false
		GsLib.app.selection = selection

func _click(mouse):
	if mouse.subject is GsHandle: pass
	elif mouse.subject: mouse.subject._click(mouse.position)
	else: GsLib.app.selection = []
