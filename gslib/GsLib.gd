extends Node
func get_class_name(): return "GsLib"

var app : GsApp
var mouse : GsMouse

func add_node(n:GsNode, select:bool=true)->GsNode:
	mouse.current_sketch.add_child(n)
	n.set_owner(mouse.current_sketch)
	if select: app.selection = [n]
	return n

func add_rect(xy:Vector2, wh=null, fill_color=null, select:bool=false)->GsNode:
	var n:GsNode = GsNode.new()
	n.rect_position = xy if wh else xy - app.DEFAULT_NODE_SIZE/2
	n.rect_size = wh if wh else app.DEFAULT_NODE_SIZE
	n.fill_color = fill_color if fill_color else app.current_fill_color
	return add_node(n, select)

func add_edge(src:GsNode, dst:GsNode, edge:GsEdge):
	# make sure it's in the tree and has a path before assigning
	var sp = src.get_parent()
	if edge.get_parent() != sp:
		sp.add_child(edge); edge.set_owner(sp)
	src.add_edge(edge); edge.src = src
	dst.add_edge(edge); edge.dst = dst
	var ix = min(src.get_index(), dst.get_index())
	if edge.get_index() > ix: sp.move_child(edge, max(0, ix-1))
