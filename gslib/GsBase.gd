@tool class_name GsBase extends Control
func get_class_name(): return 'GsBase'

@export var draggable : bool = true: set = set_draggable
@export var selected : bool = false: set = set_selected
@onready var _cloning : bool = false

signal moved(node, dxy)

func _ready():
	self.draggable = draggable

func clone()->Node:
	_cloning = true
	var copy = self._clone()
	_cloning = false
	return copy

func _clone()->Node:
	return super.duplicate()

func _gui_input(e):
	if e is InputEventMouse:
		e.position = e.global_position
		GsLib.mouse.handle(e)

func set_draggable(v):
	var m = GsLib.mouse
	if v:
		connect("mouse_entered", Callable(m, "_enter").bind(self))
		connect("mouse_exited", Callable(m, "_leave").bind(self))
	else:
		disconnect("mouse_entered", Callable(m, "_enter"))
		disconnect("mouse_exited", Callable(m, "_leave"))

func _drag_step(dxy):
	position += dxy
	emit_signal('moved', self, dxy)

func _drag_end():
	pass

func set_selected(v):
	selected = v
	queue_redraw()

func _click(_xy):
	if GsLib.mouse.shift_pressed:
		var ix = GsLib.app.selection.find(self)
		if ix > -1: GsLib.app.selection.remove_at(ix)
		else: GsLib.app.selection.append(self)
		GsLib.app.selection = GsLib.app.selection # to trigger setter
	else: GsLib.app.selection = [self]

func get_info():
	return get_class_name()
