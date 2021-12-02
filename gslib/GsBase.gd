class_name GsBase extends Control
func get_class_name(): return 'GsBase'

export var draggable : bool = true setget set_draggable
export var selected : bool = false setget set_selected
onready var _cloning : bool = false

signal moved(node, dxy)

func clone()->Node:
	_cloning = true
	var copy = self._clone()
	_cloning = false
	return copy

func _clone()->Node:
	return .duplicate()

func _enter_tree():
	mouse_filter = Control.MOUSE_FILTER_PASS

func _gui_input(e):
	if e is InputEventMouse:
		e.position = e.global_position
		GsLib.mouse.handle(e)

func set_draggable(v):
	var m = GsLib.mouse
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

func _click(xy):
	GsLib.app.selection = [self]

func get_info():
	return get_class_name()
