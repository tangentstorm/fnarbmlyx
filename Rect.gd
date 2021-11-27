tool class_name Rect extends ColorRect

export var line_color : Color = Color.black
export var line_width  : float = 1.0

func _ready():
	update()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, rect_size), line_color, false, line_width)
