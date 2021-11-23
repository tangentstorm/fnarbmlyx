class_name GsMouse extends Label
func get_class_name(): return "GsMouse"

export var sketch_path : NodePath = '/root/app/sketch'
export var grid_path : NodePath = '/root/app/grid'
export var selectangle_path : NodePath = '/root/app/selectangle'

var button_state : int = 0
var position : Vector2 = Vector2.ZERO
var dragging : bool = false
var origin : Vector2 = Vector2.ZERO
var subject : Control
var offset : Vector2 = Vector2.ZERO

onready var current_tool = $tool
onready var current_grid = get_node(grid_path)
onready var current_sketch = get_node(sketch_path)
onready var selectangle = get_node(selectangle_path)

func set_tool_script(ts:Script):
	if ts == null: ts = load('res://gs_tools/GsMouseTool.gd')
	current_tool.script = ts
	current_tool._start()
	
func drag_rect() -> Rect2:
	return Rect2(origin, position-origin)

func handle(e:InputEventMouse):
	position = e.position
	if current_grid.snap: position -= position.posmodv(current_grid.spacing)
	if e is InputEventMouseButton:
		if e.pressed:
			if e.button_index == 1:
				origin = position
				if subject:
					offset = subject.rect_position - origin 
		elif dragging:
			dragging = false
			current_tool._drag_end(self)
		else:
			current_tool._click(self)
	elif e is InputEventMouseMotion:
		if dragging:
			current_tool._drag_step(self)
		elif e.button_mask & BUTTON_LEFT:
			current_tool._drag_start(self)
			dragging = true
			
func _enter(c:Control):
	self.subject = c

func _leave(c:Control):
	self.subject = null

func _process(_dt):
	var t = '[ ' + ($tool._name() + ' ' if $tool.script else '') +'] '
	t += "(" + str(int(position.x)) + "," + str(int(position.y)) + ")"
	if dragging: t += " dragging"
	text = t
