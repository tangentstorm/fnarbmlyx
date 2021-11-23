# Tool for rapidly building networks of nodes and edges
# by clicking and dragging on nodes or the canvas.
class_name GsEdgeTool extends GsArrowTool
func get_class_name(): return "GsEdgeTool"

var src setget _set_src
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
		edge.rect_position = src.rect_position + offset
		var sketch : GsSketch = GsLib.mouse.current_sketch
		sketch.add_child(edge); edge.set_owner(sketch)
		sketch.move_child(edge, max(0, src.get_index()-1))

func _click(mouse):
	if GsLib.app.selection.size(): ._click(mouse)
	elif mouse.subject is GsNode:
		if src: _drag_end(mouse)
		else: self.src = mouse.subject
	else: self.src = GsLib.add_rect(mouse.position)

func _drag_start(mouse):
	if GsLib.app.selection.size(): ._drag_start(mouse)
	elif mouse.subject is GsNode: self.src = mouse.subject
	else: self.src = GsLib.add_rect(mouse.position)

func _drag_step(mouse):
	if GsLib.app.selection.size(): ._drag_step(mouse)
	else:
		curve.set_point_position(1, mouse.position - mouse.origin)
		edge.update()

func _drag_end(mouse):
	if GsLib.app.selection.size(): ._drag_end(mouse)
	else:
		var dst = mouse.subject
		if dst is GsNode and dst != src: pass
		else: dst = GsLib.add_rect(mouse.position)
		GsLib.add_edge(src, dst, edge)
		self.src = null
