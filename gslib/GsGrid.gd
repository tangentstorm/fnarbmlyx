tool extends Control
func get_class_name(): return "GsGrid"

export var color : Color = Color.cornflower setget _set_color
export var spacing : Vector2 = Vector2(16, 16) setget _set_spacing
export var snap : bool = true setget _set_snap

func _set_color(v):
	color = v; update()

func _set_spacing(v):
	spacing = v; update()

func _set_snap(v):
	snap = v

func _on_camera_changed(zoom, offset):
	update()

func _draw():
	var c = GsLib.camera
	var z = Vector2(1/c.zoom.x, 1/c.zoom.y)
	draw_set_transform(-(c.position+c.offset)*z, 0.0, z)

	var p0 = Vector2.ZERO
	var p1 = Vector2(rect_size.x, 0)
	var dp = Vector2.DOWN * spacing.y
	for y in range(0, rect_size.y, spacing.y):
		draw_line(p0, p1, color); p0 += dp; p1 += dp

	p0 = Vector2.ZERO; p1 = Vector2(0, rect_size.y)
	dp = Vector2.RIGHT * spacing.x
	for x in range(0, rect_size.x, spacing.x):
		draw_line(p0, p1, color); p0 += dp; p1 += dp

func _on_grid_toggled(flag):
	visible = flag
	self.snap = flag
