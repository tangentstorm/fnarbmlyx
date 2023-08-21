# Tool for rapidly building networks of nodes and edges
# by clicking and dragging on nodes or the canvas.
@tool class_name GsEdgeTool extends GsArrowTool
func get_class_name(): return "GsEdgeTool"

var src : set = _set_src
var edge : GsEdge
var curve : Curve2D
var offset : Vector2

func _set_src(v):
	src = v
	if src != null:
		curve = Curve2D.new()
		curve.add_point(Vector2.ZERO)
		curve.add_point(Vector2.ZERO)
		edge = GsEdge.new(); edge.curve = curve
		offset = src.link_offset(0)
		edge.start = src.position + offset
		GsLib.sketch.add_child(edge); edge.set_owner(GsLib.sketch)
		GsLib.sketch.move_child(edge, int(max(0, src.get_index()-1)))

func _click(mouse):
	if GsLib.app.selection.size(): super._click(mouse)
	elif mouse.find_new_subject() is GsNode:
		if src: _drag_end(mouse)
		else: self.src = mouse.subject
	else: self.src = GsLib.add_rect(mouse.position)

func _drag_start(mouse):
	if GsLib.app.selection.size(): super._drag_start(mouse)
	elif mouse.find_new_subject() is GsNode:
		self.src = mouse.subject
		mouse.subject = null
	else: self.src = GsLib.add_rect(mouse.position)

func _drag_step(mouse):
	if GsLib.app.selection.size(): super._drag_step(mouse)
	else:
		curve.set_point_position(1, mouse.position - mouse.origin)
		edge.queue_redraw()

func _drag_end(mouse):
	if GsLib.app.selection.size(): super._drag_end(mouse)
	else:
		var dst = mouse.subject
		if dst == null: dst = mouse.find_new_subject()
		if dst is GsNode and dst != src: pass
		else: dst = GsLib.add_rect(mouse.position)
		GsLib.add_edge(src, dst, edge)
		self.src = null
