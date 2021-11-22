class_name GsCurve extends Control
func get_class_name(): return "GsCurve"

export var curve : Curve2D
export var color : Color = Color.black
export var width : float = 1.0
export var antialised : bool = true

func _ready():
	if curve == null:
		curve = Curve2D.new()
		curve.add_point(Vector2.ZERO)

func add_point(xy):
	curve.add_point(xy)
	print("adding point:", xy, " len: ", curve.get_baked_length())
	update()

func _draw():
	var points = curve.get_baked_points()
	draw_polyline(points, color, width, antialised)
