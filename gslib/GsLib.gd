extends Node
func get_class_name(): return "GsLib"

var app : GsApp
var mouse : GsMouse

func add_node(n:GsNode, select:bool=true)->GsNode:
  n.set_owner(mouse.current_sketch)
  mouse.current_sketch.add_child(n)
  if select: app.selection = [n]
  return n

func add_rect(xy:Vector2, wh:Vector2=Vector2(32,32), fill_color=null, select:bool=true)->GsNode:
  var n:GsNode = GsNode.new()
  n.rect_position = xy; n.rect_size = wh; n.text = ''
  n.fill_color = fill_color if fill_color else app.current_fill_color
  return add_node(n, select)
