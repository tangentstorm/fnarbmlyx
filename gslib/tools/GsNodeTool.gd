class_name GsNodeTool extends GsMouseTool
func get_class_name(): return "GsNodeTool"

var node : GsNode

func _drag_start(mouse):
	node = GsNode.new()
	node.text = 'Node'
	node.rect_position = mouse.origin
	mouse.current_sketch.add_child(node)

func _drag_step(mouse):
	var r : Rect2 = mouse.drag_rect().abs()
	node.rect_position = r.position
	node.rect_size.x = max(node.rect_min_size.x, r.size.x)
	node.rect_size.y = max(node.rect_min_size.y, r.size.y)
	node.update()

func _drag_end(mouse):
	node = null
