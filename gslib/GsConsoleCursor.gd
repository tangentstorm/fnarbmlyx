@tool class_name GsConsoleCursor extends Control
func get_class_name(): return "GsConsoleCursor"

var fg : Color = Color.BLACK
var bg : Color = Color.GRAY
@export var ch : String = ' ': set = _set_ch
@export var font : Font
@export var base : Vector2 = Vector2(1,20)
@export var blink_rate : float = 0.5

var blink_state : bool = true

func _ready():
	var timer = Timer.new()
	timer.connect("timeout", Callable(self, '_blink'))
	timer.wait_time = blink_rate
	timer.autostart = true	
	add_child(timer)

func _blink():
	blink_state = not blink_state
	queue_redraw()

func _set_ch(v):
	ch = v
	queue_redraw()

func _draw():
	if blink_state:
		draw_rect(Rect2(Vector2.ZERO, size), bg)
