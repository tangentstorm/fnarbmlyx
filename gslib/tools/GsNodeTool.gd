@tool class_name GsNodeTool extends GsArrowTool
func get_class_name(): return "GsNodeTool"

var node : GsNode

func _drag_start(mouse):
	if mouse.find_new_subject() == null:
		node = GsNode.new()
		node.text = ''
		node.fill_color = GsLib.app.current_fill_color
		node.position = mouse.origin
		GsLib.sketch.add_child(node); node.set_owner(GsLib.sketch)
	else: super._drag_start(mouse)

func _drag_step(mouse):
	if mouse.subject: super._drag_step(mouse)
	else:
		var r : Rect2 = mouse.drag_rect().abs()
		node.position = r.position
		node.size.x = max(node.custom_minimum_size.x, r.size.x)
		node.size.y = max(node.custom_minimum_size.y, r.size.y)
		node.queue_redraw()

func _drag_end(mouse):
	if mouse.subject: super._drag_end(mouse)
	else: GsLib.app.selection = [node]
