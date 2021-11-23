class_name GsApp extends ColorRect
func get_class_name(): return "GsApp"

var ignore_mouse  : int = 0
var current_fill_color : Color = Color.white setget _set_fill_color
var current_line_color : Color = Color.black
var current_text_color : Color = Color.black
var selection : Array = [] setget _set_selection

const SELECTANGLE_PADDING = Vector2(5,5)
const DEFAULT_NODE_SIZE = Vector2(32, 32)

func _ready():
	GsLib.app = self

func _clear_selection():
	for c in GsLib.mouse.current_sketch.get_children():
		if c is GsBase: c.selected = false

func _set_selection(nodes:Array):
	_clear_selection(); selection = nodes
	if nodes.empty(): $selection.visible = false
	else:
		var xy0 = Vector2.INF; var xy1 = -Vector2.INF
		var fill = current_fill_color
		for n in nodes:
			n.selected = true
			if n is GsNode: fill = n.fill_color # keeping the last one
			var r : Rect2 = n.get_rect()
			xy0.x = min(xy0.x, r.position.x); xy1.x = max(xy1.x, r.end.x)
			xy0.y = min(xy0.y, r.position.y); xy1.y = max(xy1.y, r.end.y)
		var s = $selection; s.visible = true
		var padding = SELECTANGLE_PADDING if nodes.size() > 1 else Vector2.ZERO
		s.rect_position = xy0 - padding; s.rect_size = (xy1 - xy0) + 2 * padding
		self.current_fill_color = fill

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

func _on_delete_pressed():
	for c in $sketch.get_children():
		if c is GsBase and c.selected:
			c.queue_free()
	$selection.visible = false

func _set_fill_color(v):
	current_fill_color = v
	$toolbar/hbox/color.color = v

func _on_color_color_changed(color):
	current_fill_color = color
	for c in $sketch.get_children():
		if c is GsBase and c.selected:
			c.fill_color = color

func _on_color_pressed():
	ignore_mouse += 1

func _on_color_popup_closed():
	ignore_mouse -= 1


func _on_to_front_pressed():
	var n = $sketch.get_child_count()
	for c in $sketch.get_children():
		if c is GsBase and c.selected:
			$sketch.move_child(c, n)

func _on_to_back_pressed():
	var ch = $sketch.get_children()
	for i in range(len(ch)):
		var c : Control = ch[i]
		if c is GsBase and c.selected:
			$sketch.move_child(c, 0)
