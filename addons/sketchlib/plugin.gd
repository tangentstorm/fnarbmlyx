tool extends EditorPlugin

var scene = preload('res://addons/sketchlib/plugin.tscn')
# var scene = preload('res://gslib/GsApp.tscn')
var app

func _enter_tree():
	print("plugin _enter_tree")
	app = scene.instance()
	print("app:", app)
	#app.rect_min_size = Vector2(640,100)
	#add_control_to_bottom_panel(app, get_plugin_name())
	set_input_event_forwarding_always_enabled()
	get_editor_interface().get_editor_viewport().add_child(app)
	make_visible(false)

func _exit_tree():
	if app: app.queue_free()
	#remove_control_from_bottom_panel(app)
	#app.free()

func has_main_screen():
	return true

func make_visible(v):
	print("plugin: make_visible("+str(v)+")")
	print("app: ", app)
	if app: app.visible = v
	if app:
		print("app position:", app.rect_position)
		print("app size:", app.rect_size)

func get_plugin_name():
	return "Sketch"

func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")


# ### trying an undocumented function...
# func is_input_handled():
# 	return true

# func forward_canvas_gui_input(event):
# 	print("forwarding:", event)
# 	return true

# #func handles(object):
#	# not sure if i need this. just trying to get forward_canvas_gui_input working
#	return true
