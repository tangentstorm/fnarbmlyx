@tool class_name ColorGrid extends Control

@export var cell_size : Vector2 = Vector2(32, 32): set = set_cell_size
@export var grid_size : Vector2 = Vector2(16, 16): set = set_grid_size
@export var data = PackedByteArray([]): set = set_data

func set_cell_size(val):
	cell_size = val
	rebuild()

func set_grid_size(val):
	grid_size = val
	rebuild()

func set_data(val):
	data = val
	queue_redraw()

func rebuild():
	size = cell_size * grid_size
	data.resize(grid_size.x * grid_size.y)
	queue_redraw()

func color(i) -> Color:
	return GsPalette.arne[data[i] % 16]

func _draw():
	var i = 0
	var xy = Vector2.ZERO
	while xy.y < grid_size.y:
		xy.x = 0
		while xy.x < grid_size.x:
			draw_rect(Rect2(xy * cell_size, cell_size-Vector2.ONE), color(i))
			xy.x += 1
			i += 1
		xy.y += 1
