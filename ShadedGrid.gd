tool extends ColorRect

const cellSize = Vector2(32, 32)

func _draw():
	var xy = Vector2.ZERO
	while xy.y < rect_size.y:
		xy.x = 0
		while xy.x < rect_size.x:
			draw_rect(Rect2(xy, cellSize), Color(int(rand_range(0,64))))
			xy.x += cellSize.x
		xy.y += cellSize.y
