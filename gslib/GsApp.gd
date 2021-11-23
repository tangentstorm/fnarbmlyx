class_name GsApp extends ColorRect
func get_class_name(): return "GsApp"

var ignore_mouse : int = 0

func _input(e):
	if e is InputEventMouse and not ignore_mouse:
		if $toolbar.get_rect().has_point(e.position): pass
		else: $mouse.handle(e)

func _on_load_pressed():
	$FileDialog.current_dir = 'user://'
	$FileDialog.mode = FileDialog.MODE_OPEN_FILE
	$FileDialog.popup()

func _on_save_pressed():
	$FileDialog.current_dir = 'user://'
	$FileDialog.mode = FileDialog.MODE_SAVE_FILE
	$FileDialog.popup()

func _on_FileDialog_about_to_show():
	$fog.visible = true

func _on_FileDialog_popup_hide():
	$fog.visible = false

func _on_FileDialog_confirmed():
	var p = $FileDialog.current_path
	if not p.ends_with(".tscn"): p += ".tscn"
	_on_FileDialog_file_selected(p)

func _on_FileDialog_file_selected(path):
	match $FileDialog.mode:
		FileDialog.MODE_SAVE_FILE:
			var s = PackedScene.new()
			s.pack($sketch)
			var e = ResourceSaver.save(path, s)
			if e != OK:
				print("error on save: ", e)
		FileDialog.MODE_OPEN_FILE:
			var rsc = load(path)
			var scn = rsc.instance()
			# $sketch.replace_by(scn) # !!no: https://github.com/godotengine/godot/issues/28746
			var pos = $sketch.get_position_in_parent()
			remove_child($sketch)
			add_child(scn); scn.set_owner(self)
			move_child(scn, pos)
			$mouse.current_sketch = $sketch
	$FileDialog.hide()

func _on_clear_pressed():
	$sketch.clear()

func _on_color_color_changed(color):
	print("new color:", color)
	for c in $sketch.get_children():
		if c is GsBase and c.selected:
			c.fill_color = color

func _on_color_pressed():
	ignore_mouse += 1

func _on_color_popup_closed():
	ignore_mouse -= 1
