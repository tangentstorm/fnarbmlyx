tool class_name GsCurve extends GsBase
func get_class_name(): return "GsCurve"

export var curve : Curve2D
export var color : Color = Color.black
export var width : float = 1.0
export var antialised : bool = true
export var start : Vector2 = Vector2.ZERO setget set_start

func _ready():
	if curve == null:
		curve = Curve2D.new()
		curve.add_point(Vector2.ZERO)

func add_point(xy):
	curve.add_point(xy)
	update()

func set_start(xy):
	start = xy
	update()

func has_point(xy):
	return curve.get_closest_point(xy-start).distance_to(xy) < 15

func _draw():
	# the path points are relative to the first point,
	# which is always (0,0). We also have a start position
	# in global coordinates. rect_position cannot always
	# be the start position though, because the path may
	# move above or to the left of that point. So instead,
	# we calculate the bounding box each time we redraw.
	var tl = Vector2.ZERO
	var br = Vector2.ZERO
	var points = curve.get_baked_points()
	for p in points:
		tl.x = min(tl.x, p.x)
		tl.y = min(tl.y, p.y)
		br.x = max(br.x, p.x)
		br.y = max(br.y, p.y)
	rect_position = start + tl
	rect_size = br - tl
	# draw_rect(Rect2(Vector2.ZERO, rect_size), Color.red, false)
	draw_set_transform(-tl, 0.0, Vector2.ONE)
	draw_polyline(points, color, width, antialised)
	if selected: draw_polyline(points, Color(0xffffff33), width*2, antialised)


func _drag_step(dxy):
	start += dxy; update()
