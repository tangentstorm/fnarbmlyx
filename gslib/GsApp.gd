class_name GsApp extends ColorRect
func get_class_name(): return "GsApp"

func _input(e):
	if e is InputEventMouse:
		$mouse.handle(e)
