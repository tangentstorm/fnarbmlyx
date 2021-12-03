extends ColorRect

func _input(e):
	if e is InputEventMouse and not GsLib.app.ignore_mouse:
		GsLib.mouse.handle(e)
