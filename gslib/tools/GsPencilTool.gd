@tool extends GsMouseTool
func get_class_name(): return "GsPencilTool"

var curve : GsCurve

func _drag_start(mouse):
	curve = GsCurve.new()
	curve.start = mouse.origin
	GsLib.sketch.add_child(curve)
	curve.set_owner(GsLib.sketch)

func _drag_step(mouse):
	curve.add_point(mouse.position - mouse.origin)

func _drag_end(_mouse):
	GsLib.app.selection = [curve]
