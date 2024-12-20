@tool class_name NodeArray extends Container

@export var ref : NodePath: set = _set_ref
@export var dxy : Vector2 = Vector2.RIGHT * 32: set = _set_dxy
@export var num : int = 2: set = _set_num

@onready var node : Control = get_node(ref)

func _set_ref(v):
	ref = v
	if is_inside_tree():
		node = get_node(ref)
	rebuild()

func _set_dxy(v):
	dxy = v
	rebuild()

func _set_num(v):
	num = v
	rebuild()


func _ready():
	rebuild()

func rebuild():
	if node == null: return
	for c in get_children(): c.queue_free()
	var xy = Vector2.ZERO
	for i in range(num):
		var c : Control = node.duplicate()
		c.position = xy
		add_child(c)
		xy += dxy
