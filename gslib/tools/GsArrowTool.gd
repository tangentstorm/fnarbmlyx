class_name GsArrowTool extends GsMouseTool
func get_class_name(): return "GsArrowTool"

func _drag_start(mouse):
	if mouse.subject == null:
		mouse.selectangle.visible = true
	_drag_step(mouse)

func _drag_step(mouse):
	if mouse.subject:
		mouse.subject._drag_step(mouse.dxy)
	else:
		var r : Rect2 = mouse.drag_rect().abs()
		mouse.selectangle.rect_position = r.position
		mouse.selectangle.rect_size = r.size

func _drag_end(mouse):
	if mouse.subject: mouse.subject._drag_end()
	else:
		mouse.selectangle.visible = false
		var csk = mouse.current_sketch
		var rect = mouse.selectangle.get_rect()
		var selection = []

		for c in csk.get_children():
			if not c is GsBase: continue
			var r:Rect2 = c.get_rect()
			if r.intersects(rect):
				c.selected = true
				selection.append(c)
			else: c.selected = false
		GsLib.app.selection = selection

func _click(mouse):
	if mouse.subject == mouse.selection.get_node('drag_helper'):
		return  # TODO: what should happen?
	if mouse.subject is GsHandle: return
	if mouse.subject: GsLib.app.selection = [mouse.subject]
	else: GsLib.app.selection = []
