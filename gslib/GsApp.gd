class_name GsApp extends ColorRect
func get_class_name(): return "GsApp"

func _input(e):
	if $fog.visible: pass
	elif e is InputEventMouse:
		$mouse.handle(e)

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
