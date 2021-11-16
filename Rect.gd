tool extends ColorRect

export var strokeColor : Color = Color.black
export var strokeWidth  : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, rect_size), strokeColor, false, strokeWidth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
