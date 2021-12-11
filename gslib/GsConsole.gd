tool class_name GsConsole extends Control

export var font : Font = preload("res://fonts/noto-font.tres")
export var font_base : Vector2 = Vector2(1,20)

export var rng_seed : int = 82076 setget _set_rng_seed
export var grid_wh : Vector2 = Vector2(80, 25)
export var cell_wh : Vector2 = Vector2(16,26)
export var cursor_visible: bool = true setget _set_cursor_visible

var cursor_xy : Vector2 = Vector2.ZERO
var fg : Color = Color.gray
var bg : Color = Color.black

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var FGB : PoolColorArray
var BGB : PoolColorArray
var CHB : PoolIntArray # unicode code points

func _set_rng_seed(v):
	rng_seed = v
	rng.seed = v

func _set_cursor_visible(v):
	cursor_visible = v
	if $cursor: $cursor.visible = v

func _ready():
	var cursor = GsConsoleCursor.new()
	cursor.rect_size = cell_wh
	cursor.name = "cursor"
	add_child(cursor)
	_set_cursor_visible(cursor_visible)
	_reset()
	_cscr()

func _reset():
	fg = Color.gray
	bg = Color.black

func _cscr():
	FGB = PoolColorArray()
	BGB = PoolColorArray()
	CHB = PoolIntArray()
	for i in range(grid_wh.x * grid_wh.y):
		FGB.append(fg)
		BGB.append(bg)
		CHB.append(32)

func _rnd():
	# fill buffer with random colored characters
	# ("screen saver" for debugging / fps checks)
	for i in range(grid_wh.x * grid_wh.y):
		FGB[i] = 0x333333ff + (rng.randi_range(0, 0xcccccc) << 8)
		BGB[i] = Color.black
		CHB[i] = rng.randi_range(33,126)
	update()

func _draw():
	var w = 80; var h = 16	
	for y in range(grid_wh.y):
		for x in range(grid_wh.x):
			var xy = Vector2(x,y)*cell_wh
			var p = y * grid_wh.x + x
			draw_rect(Rect2(xy, cell_wh), BGB[p])
			draw_char(font, xy+font_base, char(CHB[p]), ' ', FGB[p])
