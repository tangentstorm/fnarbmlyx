@tool extends ColorRect

@export var cell_size : Vector2 = Vector2(32, 32)
@export var rng_seed : int = 82076: set = set_seed
var rng = RandomNumberGenerator.new()

func set_seed(v):
	rng_seed = v
	rng.seed = v
	queue_redraw()

func _draw():
	var xy = Vector2.ZERO
	while xy.y < size.y:
		xy.x = 0
		while xy.x < size.x:
			draw_rect(Rect2(xy, cell_size), Color(rng.randi_range(0,64)))
			xy.x += cell_size.x
		xy.y += cell_size.y
