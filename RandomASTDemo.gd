extends Control

var node_radius = 16
var gap = 2
var DEPTH = 5
var MAXNODES = 32

class TreeNode:
	var label : String
	var nodes : Array
	var count : int = 1

	func _init(label: String, nodes=[]):
		self.label = label
		self.nodes = nodes
		for n in nodes: self.count += n.count

func build_subtree(height, maxnodes) -> TreeNode:
	if maxnodes <= 2: return TreeNode.new('o')
	var cut = 1 + randi() % maxnodes
	var lhs = build_subtree(height-1, cut)
	var rhs = build_subtree(height-1, maxnodes-cut)
	return TreeNode.new('x', [lhs, rhs])

var tree : TreeNode
func _ready():
	self.tree = build_subtree(5, MAXNODES)
	var scene = build_scene(self.tree)
	scene.rect_position = rect_size * 0.25
	add_child(scene)
	
func build_scene(t:TreeNode) -> Control:
	var lbl = Label.new(); lbl.text = t.label
	lbl.align = Label.ALIGN_CENTER
	lbl.valign =Label.VALIGN_TOP
	var vb:VBoxContainer = VBoxContainer.new()
	vb.alignment =BoxContainer.ALIGN_CENTER
	vb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vb.add_child(lbl)
	var row = HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	if t.nodes:
		for tn in t.nodes:
			row.add_child(build_scene(tn))
		vb.add_child(row)
	else:
		vb.add_child(PanelContainer.new())
	var panel = PanelContainer.new()
	panel.add_child(vb)
	return panel
	
