class_name GsApp extends Control
func get_class_name(): return "GsApp"

export var current_fill_color : Color = Color.white setget _set_fill_color
export var current_line_color : Color = Color.black
export var current_text_color : Color = Color.black
var selection : Array setget _set_selection

const SELECTANGLE_PADDING = Vector2(5,5)
const DEFAULT_NODE_SIZE = Vector2(32, 32)

func _ready():
	GsLib.app = self
	self.current_fill_color = current_fill_color
	GsLib.camera.connect('camera_changed', $bg/grid, '_on_camera_changed')

func _clear_selection():
	for c in GsLib.sketch.get_children():
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
		_set_fill_color(fill, true, false)
	if nodes.size() == 1:
		$ui/inspector.set_item(nodes[0])

func _on_load_pressed():
	$ui/FileDialog.current_dir = 'user://'
	$ui/FileDialog.mode = FileDialog.MODE_OPEN_FILE
	$ui/FileDialog.popup()

func _on_save_pressed():
	$ui/FileDialog.current_dir = 'user://'
	$ui/FileDialog.mode = FileDialog.MODE_SAVE_FILE
	$ui/FileDialog.popup()

func _on_FileDialog_about_to_show():
	$ui/fog.visible = true

func _on_FileDialog_popup_hide():
	$ui/fog.visible = false

func _on_FileDialog_confirmed():
	var p = $ui/FileDialog.current_path
	if not p.ends_with(".tscn"): p += ".tscn"
	_on_FileDialog_file_selected(p)

func _on_FileDialog_file_selected(path):
	match $ui/FileDialog.mode:
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
			GsLib.sketch = $sketch
	$ui/FileDialog.hide()

func _on_clear_pressed():
	$sketch.clear()

func _on_delete_pressed():
	for c in $sketch.get_children():
		if c is GsBase and c.selected:
			c.queue_free()
	$selection.visible = false

func _set_fill_color(v, tell_ui=true, paint_selection=true):
	current_fill_color = v
	if is_inside_tree():
		if tell_ui: $ui/toolbar/hbox/color.color = v
		if paint_selection:
			for c in selection:
				if c is GsNode: c.fill_color = v

func _on_color_color_changed(color):
	_set_fill_color(color, false)

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

func _on_palette_clicked(_node, _x, _y, _i, color):
	_set_fill_color(color)


## context menu
enum CMD { DELETE, DUPLICATE, GROUP, UNGROUP, ARRANGE_ROW, ARRANGE_COL }
const CMDS = ['Delete', 'Duplicate', 'Group', 'Ungroup', 'Row', 'Column']

func _on_context_menu_id_pressed(id):
	match id:
		CMD.DELETE: _on_delete_pressed()
		CMD.DUPLICATE: cmd_duplicate()
		CMD.GROUP: cmd_group()
		CMD.UNGROUP: cmd_ungroup()

const SHIFT = 16 * Vector2.ONE
func cmd_duplicate():
	var o2n = {}; var n2o = {}; var newsel = []
	for o in selection:
		var n = o.clone(); newsel.append(n); n.set_name('n_' + o.get_name())
		if n is GsEdge:
			n.src_path=''; n.dst_path=''; n.src = null; n.dst = null
			n.color = Color.red
		if n is GsNode:
			n.edge_refs = []; n.edges = []
		$sketch.add_child(n); n.set_owner($sketch)
		o2n[o.get_name()] = n; n2o[n.get_name()] = o

	# it duplicates the connections so remove old connections to new edges
	for o in selection:
		if o is GsNode:
			for e in o.edges:
				if e and n2o.has(e.get_name()):
					o.rm_edge(n2o[e.get_name()])

#	for e in newsel:
#		if e is GsEdge:
#			if e.src and map.has(e.src.get_name()):
#				e.start += SHIFT
#				e.src.rm_edge(map[e.get_name()])
#				print('rm_edge:', e.src.get_name(), '->', map[e.get_name()].get_name())
#				n = map[e.src.get_name()]; n.add_edge(e); e.src = n
#			if e.dst and map.has(e.dst.get_name()):
#				print('rm_edge:', e.dst.get_name(), '->', map[e.get_name()].get_name())
#				n = map[e.dst.get_name()]; n.add_edge(e); e.dst = n

	self.selection = newsel

func cmd_group():
	if selection.size():
		var g = GsLib.add_group($selection.rect_position, $selection.rect_size)
		for item in selection:
			GsLib.sketch.remove_child(item)
			g.add_item(item)
		self.selection = [g]

func cmd_ungroup():
	var newsel = []
	for x in selection:
		if x is GsGroup: newsel.append_array(x.ungroup())
		else: newsel.append(x)
	self.selection = newsel

func _on_context_menu_about_to_show():
	$ui/context_menu.clear()
	for cmd in CMD.values():
		$ui/context_menu.add_item(CMDS[cmd], cmd)
		if (cmd==CMD.ARRANGE_ROW or cmd==CMD.ARRANGE_COL):
			$ui/context_menu.set_item_disabled(cmd, true)

func _unhandled_input(e):
	if e is InputEventMouse:
		GsLib.mouse.handle(e)
