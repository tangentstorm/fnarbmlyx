extends GsMouseTool
func get_class_name(): return "GsPencilTool"

var curve : GsCurve

func _drag_start(mouse):
	curve = GsCurve.new()
	curve.rect_position = mouse.origin
	mouse.current_sketch.add_child(curve)
	curve.set_owner(mouse.current_sketch)

func _drag_step(mouse):
	curve.add_point(mouse.position - mouse.origin)
