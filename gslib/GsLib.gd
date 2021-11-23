extends Node
func get_class_name(): return "GsLib"

var app : GsApp
var mouse : GsMouse

func add_node(n:GsNode, select:bool=true)->GsNode:
	n.set_owner(mouse.current_sketch)
	mouse.current_sketch.add_child(n)
	if select: app.selection = [n]
	return n

func add_rect(xy:Vector2, wh=null, fill_color=null, select:bool=false)->GsNode:
	var n:GsNode = GsNode.new()
	n.rect_position = xy if wh else xy - app.DEFAULT_NODE_SIZE/2
	n.rect_size = wh if wh else app.DEFAULT_NODE_SIZE
	n.fill_color = fill_color if fill_color else app.current_fill_color
	return add_node(n, select)

func add_edge(src:GsNode, dst:GsNode, curve:GsCurve):
	pass
