@tool class_name TruthTable extends Control

@export var nvars : int = 5: set = _set_nvars
@export var bits : int = 0: set = _set_bits
@export var cellSize : Vector2 = Vector2(32, 32): set = _set_cellSize

func _set_nvars(v):
	nvars = int(clamp(v, 0, 5))
	queue_redraw()

func _set_bits(v):
	bits = v
	queue_redraw()

func _set_cellSize(v):
	cellSize = v
	queue_redraw()

func _draw():
	var w = 1 << nvars
	self.custom_minimum_size = Vector2(cellSize.x * w, cellSize.y)
	var xy = Vector2((w-1) * cellSize.x, 0)
	for i in range(0, w):
		var c = Color(0xEEEEEEFF) if 0<bits&(1<<i) else Color(0x222222FF)
		draw_rect(Rect2(xy, cellSize), c)
		draw_rect(Rect2(xy, cellSize), Color.BLACK, false)
		xy.x -= cellSize.x
