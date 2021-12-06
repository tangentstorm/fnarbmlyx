tool class_name GsIndexedImage extends Control
func get_class_name(): return 'GsIndexedImage'

signal clicked(node,x,y,i,color)

export var shape : Vector2 = Vector2(8,2) setget _set_shape
export var cell_size : Vector2 = Vector2(16, 16) setget _set_cell_size
export (Array, Color) var palette = GsPalette.arne setget _set_palette
export var data : PoolByteArray setget _set_data

func _set_shape(v):
	shape = v; _rebuild()

func _set_cell_size(v):
	cell_size = v; _rebuild()

func _set_palette(v):
	data = v; _rebuild()

func _set_data(v):
	data = v; _rebuild()

func _ready():
	_rebuild()

func _rebuild():
	rect_min_size = cell_size * shape
	data = PoolByteArray()
	for i in range(len(palette)):
		data.append(i)
	update()

func _draw():
	var i = 0
	for row in range(shape.y):
		var xy = Vector2(0, row * cell_size.y)
		for _x in range(shape.x):
			draw_rect(Rect2(xy, cell_size), palette[data[i]])
			xy.x += cell_size.x; i += 1

func _gui_input(e):
	if e is InputEventMouseButton:
		if e.pressed:
			var y = int(floor(e.position.y / cell_size.y))
			var x = int(floor(e.position.x / cell_size.x))
			var i = data[y * shape.x + x]
			var c:Color = palette[i]
			emit_signal("clicked", self, x, y, i, c)
