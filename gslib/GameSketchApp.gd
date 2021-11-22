extends ColorRect
func get_class_name(): return "GameSketchApp"

func _input(e):
	if e is InputEventMouse:
		$mouse.handle(e)
