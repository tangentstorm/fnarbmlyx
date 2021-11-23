extends GsMouseTool
func get_class_name(): return "GsArrowTool"

func _drag_start(mouse):
	if mouse.subject == null:
		mouse.selectangle.visible = true
	_drag_step(mouse)

func _drag_step(mouse):
	if mouse.subject:
		mouse.subject._drag_step(mouse.position + mouse.offset, self)
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
		var xy0 = Vector2.INF; var xy1 = -Vector2.INF
		var selection = []

		for c in csk.get_children():
			if not c is GsBase: continue
			var r:Rect2 = c.get_rect()
			if r.intersects(rect):
				c.selected = true
				selection.append(c)
				xy0.x = min(xy0.x, r.position.x)
				xy0.y = min(xy0.y, r.position.y)
				xy1.x = max(xy1.x, r.end.x)
				xy1.y = max(xy1.y, r.end.y)
			else: c.selected = false

		var s:Control = mouse.selection
		if selection.size():
			s.rect_position = xy0 - Vector2(5,5)
			s.rect_size = (xy1 - xy0) + Vector2(10,10)
			s.visible = true
			for c in selection:
				if c is GsNode:
					$"/root/app".current_fill_color = c.fill_color
					break
		else: s.visible = false

func _click(mouse):
	if mouse.subject == mouse.selection.get_node('drag_helper'):
		return  # TODO: what should happen?
	if mouse.subject is GsHandle: return
	for c in mouse.current_sketch.get_children():
		if c is GsBase: c.selected = false
	if mouse.subject:
		mouse.subject.selected = true
		if mouse.subject is GsNode:
			$"/root/app".current_fill_color = mouse.subject.fill_color
		var s:Control = mouse.selection
		s.rect_position = mouse.subject.rect_position - Vector2(5,5)
		s.rect_size = mouse.subject.rect_size + Vector2(10,10)
		s.visible = true
	else: mouse.selection.visible = false
