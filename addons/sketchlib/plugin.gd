tool extends EditorPlugin

var scene = preload('res://addons/sketchlib/plugin.tscn')
var app

func forward_canvas_gui_input(event):
	return true

func _enter_tree():
	var app = scene.instance()
	app.rect_min_size = Vector2(640,100)
	add_control_to_bottom_panel(app, 'sketch')
	set_input_event_forwarding_always_enabled()

func handles(object):
	return true

func _exit_tree():
	remove_control_from_bottom_panel(app)
	app.free()
