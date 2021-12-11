tool class_name GsNode extends GsBase
func get_class_name(): return "GsNode"

const NOTO = preload("res://fonts/noto-font.tres")

enum SHAPE { DISK, RECT }
export(SHAPE) var shape = SHAPE.RECT setget _set_shape
export var fill_color : Color = Color.white setget _set_fill_color
export var line_color : Color = Color.black setget _set_line_color
export var text_color : Color = Color.black setget _set_text_color
export var text : String = '' setget _set_text
export var font : Font = NOTO setget _set_font
export (Array, NodePath) var edge_refs : Array setget _set_edge_refs
var edges : Array # Array[GsEdge]

func _clone():
	var c = .duplicate(0)
	for slot in get_property_list():
		var k = slot['name']
		if not k in ['edges', 'edge_refs']:
			c.set(k, get(k))
	return c

func _set_shape(v):
	shape = v; update()

func _set_fill_color(v):
	fill_color = v; update()

func _set_line_color(v):
	line_color = v; update()

func _set_text_color(v):
	text_color = v; update()

func _set_font(v):
	font = v; update()

func _set_text(v):
	text = v
	if text == '': rect_min_size = Vector2.ONE * 32
	else:
		var size = font.get_string_size(text)
		rect_min_size.x = max(32, size.x)
		rect_min_size.y = max(32, size.y)
	update()

func _clear_edges():
	edges = []; edge_refs = []

func _set_edge_refs(vs):
	# wait until all nodes are loaded before attempting to
	# re-establish connections (else it may fail when re-loading a graph)
	if not _cloning:
		call_deferred('_set_edge_refs_deferred', vs)

func _set_edge_refs_deferred(vs):
	if is_inside_tree():
		_clear_edges()
		for v in vs: add_edge_ref(v)
	else: edge_refs = vs

func add_edge(e):
	edge_refs.append(e.get_path()); edges.append(e)
	# print("CONNECT: ", self.get_name(), " -> ", e.get_name())
	connect("item_rect_changed", e, '_on_node_moved')

func rm_edge(e):
	print('rm_edge:', e)
	var ix = edges.find(e)
	if ix > -1:
		edges.remove(ix); edge_refs.remove(ix)
		# print("DISCONNECT: ", self.get_name(), " -> ", e.get_name())
		disconnect("item_rect_changed", e, '_on_node_moved')

func add_edge_ref(ref):
	add_edge(get_node(ref))

func _draw():
	var center = link_offset(0)
	var radius = rect_min_size.x * 0.5

	for c in get_children():
		draw_line(center, c.rect_position + c.link_point(0), Color.black, 1.5, true)

	match shape:
		SHAPE.RECT:
			draw_rect(Rect2(Vector2.ZERO, rect_size), fill_color, true)
			draw_rect(Rect2(Vector2.ZERO, rect_size), line_color, false)
		SHAPE.DISK:
			draw_circle(center, radius, fill_color)
			var num = 32; var pts = PoolVector2Array()
			for i in range(num+1):
				var t = deg2rad(i * 360 / num)
				pts.push_back(center + Vector2(cos(t), sin(t)) * radius)
			for i in range(num):
				draw_line(pts[i], pts[i+1], line_color, 1.0, true)

	var baseline = font.get_ascent() - 2
	var text_size = font.get_string_size(text)
	var xy = Vector2(center.x - (text_size.x * 0.5), baseline)
	draw_string(font, xy, text, text_color)

	if selected and GsLib.app.selection.size() > 1:
		var pad = Vector2(5,5)
		draw_rect(Rect2(-pad, rect_size + 2*pad), Color(0xffffff66), true)

func link_offset(_i:int=0):
	# link_point 0 = center. others can be added later
	return Vector2(rect_size.x, rect_size.y) * 0.5

func link_point(i:int):
	# link_point 0 = center. others can be added later
	return rect_position + link_offset(i)
