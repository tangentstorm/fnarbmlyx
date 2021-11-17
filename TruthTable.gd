class_name TruthTable
tool extends Control

export var nvars : int = 5 setget _set_nvars
export var bits : int = 0 setget _set_bits
export var cellSize : Vector2 = Vector2(32, 32) setget _set_cellSize

func _set_nvars(v):
	nvars = int(clamp(v, 0, 5))
	update()

func _set_bits(v):
	bits = v
	update()

func _set_cellSize(v):
	cellSize = v
	update()

func _draw():
	var w = 1 << nvars
	self.rect_min_size = Vector2(cellSize.x * w, cellSize.y)
	var xy = Vector2((w-1) * cellSize.x, 0)
	for i in range(0, w):
		var c = Color(0xEEEEEEFF) if 0<bits&(1<<i) else Color(0x222222FF)
		draw_rect(Rect2(xy, cellSize), c)
		draw_rect(Rect2(xy, cellSize), Color.black, false)
		xy.x -= cellSize.x
