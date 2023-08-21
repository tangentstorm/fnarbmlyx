@tool class_name ASTNodeDemo extends Control

@export var rng_seed : int = 82076: set = _set_rng_seed
var node_radius = 16
var gap = 2
var DEPTH = 5
var MAXNODES = 32

func _set_rng_seed(v):
	rng_seed = v
	if is_inside_tree(): rebuild()

class TreeNode:
	var value
	var nodes : Array
	var count : int = 1
	var height: int = 0

	func _init(value, nodes=[]):
		self.value = value
		self.nodes = nodes
		var maxh = 0
		for n in nodes:
			self.count += n.count
			if n.height > maxh: maxh = n.height
		self.height = maxh + 1

func build_subtree(rng:RandomNumberGenerator, height, maxnodes) -> TreeNode:
	if maxnodes <= 2:
		return TreeNode.new(ASTNode.OP.values()[rng.randi_range(0, ASTNode.OP.I)])
	var cut = 1 + rng.randi() % maxnodes
	var lhs = build_subtree(rng, height-1, cut)
	var rhs = build_subtree(rng, height-1, maxnodes-cut)
	var ops = [ASTNode.OP.AND, ASTNode.OP.OR, ASTNode.OP.XOR]
	return TreeNode.new(ops[rng.randi_range(0,len(ops)-1)], [lhs, rhs])

var tree : TreeNode
func _ready():
	rebuild()
	
func rebuild():
	for c in get_children(): c.queue_free()
	var rng = RandomNumberGenerator.new()
	rng.seed = rng_seed
	self.tree = build_subtree(rng, 5, MAXNODES)
	var scene = build_scene(self.tree)
	size = get_viewport().size
	scene.position = (size - scene.size) * 0.5
	add_child(scene)
	
var ASTScene = preload("res://demos/boolean_syntax_tree/ASTNode.tscn")
func build_scene(t:TreeNode) -> Container:
	var res = ASTScene.instantiate()
	res.op = t.value
	for tn in t.nodes:
		res.add_child(build_scene(tn))
	res.layout()
	return res
