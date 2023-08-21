# Overlap Demo ported to Godot
# (the chunks of dead code here are meant to be stepping stones for
# narrative presentation if I decide to record a video of this.)
extends ColorRect

var subject : Control = null
var offset  : Vector2 = Vector2.ZERO
var boxes   : Array

func colorize_overlaps(pressed=false):
	# brute force method - O(n^2)
	# quadtree might be more appropriate with large numbers of boxes
	for c in boxes: c.color = Color.WHITE
	for c0 in boxes:
		var r0 = c0.get_rect()
		for c1 in boxes:
			if c1==c0: break
			if r0.intersects(c1.get_rect()):
				c0.color = Color.DIM_GRAY
				c1.color = Color.DIM_GRAY
	if pressed:
		subject.color = (Color.GOLDENROD if subject.color == Color.WHITE
			else Color.BLACK)

func _input(e):
	if e is InputEventMouseMotion:
		$mouseXY.text = str(e.position)
		if subject and e.button_mask:
			subject.position = e.position + offset
#			var r = subject.get_rect()
#			for c in get_children():
#				if c is ColorRect and c != subject:
#					if c.get_rect().intersects(r): c.color = Color.gray
#					else: c.color = Color.white
			colorize_overlaps(1==(e.button_mask&1))

	if e is InputEventMouseButton:
		if subject:
			#subject.color = Color.goldenrod if e.pressed else Color.gold
			colorize_overlaps(e.pressed)
			if e.pressed:
				offset = subject.position - e.position
				move_child(subject,get_child_count())
#		for c in get_children():
#			if c is ColorRect:
#				if c.get_rect().has_point(e.position): c.color = Color.goldenrod
#				else: c.color = Color.white

func _ready():
	for y in range(0, 3):
		for x in range(0, 3):
			var o = ColorRect.new()
			o.size = Vector2(32, 32)
			o.position = Vector2(50 + 75 * x, 50 + 75 * y)
			add_child(o)
			o.connect("mouse_entered", Callable(self, "on_mouse_enter").bind(o))
			o.connect("mouse_exited", Callable(self, "on_mouse_leave")) #, [o])
			boxes.append(o)

func on_mouse_enter(x):
	subject = x
	x.color = Color.cornflower

func on_mouse_leave():
	subject = null
	# x.color = Color.white
	colorize_overlaps()
