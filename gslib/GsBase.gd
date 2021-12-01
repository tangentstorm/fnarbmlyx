class_name GsBase extends Control

export var draggable : bool = true setget set_draggable
export var selected : bool = false setget set_selected

signal moved(node, dxy)

func _enter_tree():
	mouse_filter = Control.MOUSE_FILTER_PASS

func _gui_input(e):
	if e is InputEventMouse:
		e.position = e.global_position
		_get_mouse().handle(e)

func _get_mouse():
	return $"/root/app/mouse"

func set_draggable(v):
	var m = _get_mouse()
	if v:
		connect("mouse_entered", m, "_enter", [self])
		connect("mouse_exited",  m, "_leave", [self])
	else:
		disconnect("mouse_entered", m, "_enter")
		disconnect("mouse_exited",  m, "_leave")

func _drag_step(dxy):
	rect_position += dxy
	emit_signal('moved', self, dxy)

func _drag_end():
	pass

func set_selected(v):
	selected = v
	update()
