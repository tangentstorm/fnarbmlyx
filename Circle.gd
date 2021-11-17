class_name Circle
tool extends RigidBody2D

signal mbld

export var radius : float = 16
export var fill : Color = Color.whitesmoke
export var stroke : Color = Color.black

var held : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func _draw():
	draw_circle(Vector2(0,0), radius, stroke)
	draw_circle(Vector2(0,0), radius-2, fill)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("mbld", self)

func grab():
	mode = RigidBody2D.MODE_STATIC
	held = true

func drop(impulse=Vector2.ZERO):
	# next line would re-enable physics, but let's not:
	# mode = RigidBody2D.MODE_RIGID
	held = false
	apply_central_impulse(impulse)

func _physics_process(_dt):
	if held:
		global_transform.origin = get_global_mouse_position()
