tool class_name GsNodeTool extends GsArrowTool
func get_class_name(): return "GsNodeTool"

var node : GsNode

func _drag_start(mouse):
	if mouse.find_new_subject() == null:
		node = GsNode.new()
		node.text = ''
		node.fill_color = GsLib.app.current_fill_color
		node.rect_position = mouse.origin
		GsLib.sketch.add_child(node); node.set_owner(GsLib.sketch)
	else: ._drag_start(mouse)

func _drag_step(mouse):
	if mouse.subject: ._drag_step(mouse)
	else:
		var r : Rect2 = mouse.drag_rect().abs()
		node.rect_position = r.position
		node.rect_size.x = max(node.rect_min_size.x, r.size.x)
		node.rect_size.y = max(node.rect_min_size.y, r.size.y)
		node.update()

func _drag_end(mouse):
	if mouse.subject: ._drag_end(mouse)
	else: GsLib.app.selection = [node]
