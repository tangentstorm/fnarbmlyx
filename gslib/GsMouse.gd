class_name GsMouse extends Label
func get_class_name(): return "GsMouse"

export var grid_path : NodePath = '/root/app/bg/grid'
export var selectangle_path : NodePath = '/root/app/selectangle'
export var selection_path : NodePath = '/root/app/selection'

var button_state : int = 0
var position : Vector2 = Vector2.ZERO
var dxy : Vector2 = Vector2.ZERO
var dragging : bool = false
var origin : Vector2 = Vector2.ZERO
var subject : Control

onready var current_tool = $tool
onready var current_grid = get_node(grid_path)
onready var selectangle = get_node(selectangle_path)
onready var selection = get_node(selection_path)

func _ready():
	GsLib.mouse = self

func set_tool_script(ts:Script):
	if ts == null: ts = load('res://gs_tools/GsMouseTool.gd')
	current_tool.script = ts
	current_tool._start()
	
func drag_rect() -> Rect2:
	return Rect2(origin, position-origin)

func context_menu(xy:Vector2):
	var m = $"/root/app/ui/context_menu"
	m.rect_position = xy
	m.popup()


func handle(e:InputEventMouse):
	var o = e.position;
	var c = GsLib.camera
	var p = c.screen_to_world(o)
	if current_grid and current_grid.snap:
		p -= p.posmodv(current_grid.spacing)
	dxy = p - position
	position = p
	if e is InputEventMouseButton:
		if e.pressed:
			match e.button_index:
				BUTTON_LEFT: origin = position
				BUTTON_RIGHT: context_menu(position)
				BUTTON_WHEEL_UP: GsLib.camera.zoom_at(o, -0.1)
				BUTTON_WHEEL_DOWN: GsLib.camera.zoom_at(o, 0.1)
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
	var t = ''
	if subject: t += '<'+subject.get_path()+' ('+subject.get_class_name()+')> '
	t += '[ ' + ($tool._name() + ' ' if $tool.script else '') +'] '
	t += "(" + str(int(position.x)) + "," + str(int(position.y)) + ")"
	if dragging: t += " dragging"
	text = t

func find_new_subject(xy=null):
	if xy == null: xy = position
	var ns = GsLib.sketch.get_children()
	self.subject = null
	for i in range(len(ns)-1, 0, -1):
		if ns[i] is GsNode and ns[i].get_rect().has_point(position):
			self.subject = ns[i]
			break
	return subject
