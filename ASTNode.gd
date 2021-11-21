class_name ASTNode
tool extends Container

enum OP { X0,X1,X2,X3,X4,O,I,AND,OR,XOR,ITE,MAJ,NONE }
enum SHAPE { DISK, RECT }

const op_text = [
	"x\u2080","x\u2081","x\u2082","x\u2083", "x\u2084",
	"⊥", "⊤", "∧", "∨", "≠", "C", "M"]
export(OP) var op = OP.X0 setget _set_op
export(SHAPE) var shape = SHAPE.DISK setget _set_shape
export var fill_color : Color = Color.white setget _set_fill_color
export var line_color : Color = Color.black setget _set_line_color
export var text_color : Color = Color.black setget _set_text_color
export var text : String = "" setget _set_text
export var font : Font setget _set_font

func _set_op(v):
	op = v
	if (op == OP.NONE) or (op == null): return # update()
	text = op_text[op]
	text_color = Color.white if op == OP.I or op < OP.O else Color.black
	shape = SHAPE.DISK if op > OP.I else SHAPE.RECT
	match op:
		OP.I: fill_color = Color('222')
		OP.O: fill_color = Color('eee')
		OP.X0, OP.X1, OP.X2, OP.X3, OP.X4:
			# text = OP.keys()[op].to_lower()
			fill_color = Color('597dce')
		OP.AND: fill_color = Color('d27d2c')
		OP.XOR: fill_color = Color('d2aa99')
		OP.OR: fill_color = Color('dad45e')
		OP.ITE, OP.MAJ:
			fill_color = Color('d04648')
	update()

func _set_shape(v):
	shape = v; update()
func _set_fill_color(v):
	fill_color = v; update()
func _set_line_color(v):
	line_color = v; update()
func _set_text_color(v):
	text_color = v; update()
func _set_font(v):
	font = v; update()
func _set_text(v):
	text = v; update()

func get_class():
	return 'ASTNode'

func link_point(_i:int=0):
	# link_point 0 = center.
	# others can be added later
	return Vector2(rect_size.x, rect_min_size.y) * 0.5
	
func layout():
	var gap_y = 16 if get_child_count() else 0
	var total_w = 0; var child_h = 0
	var xy = Vector2(0, rect_min_size.y + gap_y)
	var children = get_children()
	for i in range(get_child_count()):
		var c = children[i]
		var gap_x = 8 if i + 1 < len(children) else 0
		fit_child_in_rect(c, Rect2(xy, c.rect_size))
		child_h = max(child_h, c.rect_size.y)
		total_w += c.rect_size.x + gap_x
		xy += Vector2(c.rect_size.x + gap_x, 0)
	total_w = max(total_w, rect_min_size.x)
	rect_size = Vector2(total_w, child_h + gap_y + rect_min_size.y)

func _notification(x):
	if x == NOTIFICATION_SORT_CHILDREN:
		self.layout()

func _draw():
	var center = link_point(0)
	var radius = rect_min_size.x * 0.5

	for c in get_children():
		draw_line(center, c.rect_position + c.link_point(0), Color.black, 1.5, true)

	match shape:
		SHAPE.RECT:
			var xy = Vector2(center.x - radius, 0)
			draw_rect(Rect2(xy, rect_size), fill_color, true)
			draw_rect(Rect2(xy, rect_size), line_color, false)
		SHAPE.DISK:
			draw_circle(center, radius, fill_color)
			var num = 32; var pts = PoolVector2Array()
			for i in range(num+1):
				var t = deg2rad(i * 360 / num)
				pts.push_back(center + Vector2(cos(t), sin(t)) * radius)
			for i in range(num):
				draw_line(pts[i], pts[i+1], line_color, 1.0, true)
	
	var baseline = font.get_ascent() - 2
	var text_size = font.get_string_size(text)
	var xy = Vector2(center.x - (text_size.x * 0.5), baseline)
	print('text:', text)
	draw_string(font, xy, text, text_color)
	

