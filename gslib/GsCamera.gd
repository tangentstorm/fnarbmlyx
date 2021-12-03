class_name GsCamera extends Camera2D
func get_class_name(): return 'GsCamera'

signal camera_changed(new_zoom, new_offset)

func _ready():
	GsLib.camera = self

func screen_to_world(xy:Vector2)->Vector2:
	return (xy * zoom) + offset + position

func zoom_at(xy, dzoom):
	# print('zoom_at(xy:', xy, ', dzoom:', dzoom, ') offset:', offset, ' position: ', position)
	position += xy * zoom
	zoom = Vector2.ONE * max(0.1, zoom.x + dzoom)
	position -= xy * zoom
	emit_signal('camera_changed', zoom, offset)
