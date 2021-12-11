tool class_name GsConsoleCursor extends Control
func get_class_name(): return "GsConsoleCursor"

var fg : Color = Color.black
var bg : Color = Color.gray
export var ch : String = ' ' setget _set_ch
export var font : Font
export var base : Vector2 = Vector2(1,20)
export var blink_rate : float = 0.5

var blink_state : bool = true

func _ready():
	var timer = Timer.new()
	timer.connect("timeout", self, '_blink')
	timer.wait_time = blink_rate
	timer.autostart = true	
	add_child(timer)

func _blink():
	blink_state = not blink_state
	update()

func _set_ch(v):
	ch = v
	update()

func _draw():
	if blink_state:
		draw_rect(Rect2(Vector2.ZERO, rect_size), bg)
