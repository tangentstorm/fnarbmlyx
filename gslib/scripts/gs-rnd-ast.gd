# draw a random AST
extends Node2D

enum BFn { X0, X1, X2, X3, X4, O, I, AND, OR, XOR, NONE } # ITE, MAJ ?
const R = GsNode.SHAPE.RECT; const D = GsNode.SHAPE.DISK
const THEME = { # shape, textcolor, bgcolor, text
	'X0' : [R, 'fff', '597dce', "x\u2080"],
	'X1' : [R, 'fff', '597dce', "x\u2081"],
	'X2' : [R, 'fff', '597dce', "x\u2082"],
	'X3' : [R, 'fff', '597dce', "x\u2083"],
	'X4' : [R, 'fff', '597dce', "x\u2084"],
	'O'  : [R, 'fff', '222222', "⊥"],
	'I'  : [R, '000', 'eeeeee', "⊤"],
	'AND': [D, '000', 'd27d2c', "∧"],
	'OR' : [D, '000', 'dad45e', "∨"],
	'XOR': [D, '000', 'd2aa99', "≠"],
}
const DIM_NODE = Color(0xffffff99)

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	rng.seed = 322
	var trace = []
	var tree = sprout(trace, Vector2.ZERO, 32)
	var co = animate(trace, tree)
	while co is GDScriptFunctionState:
		yield($Timer, "timeout")
		co = co.resume()

func init_state():
	var state = {}
	state['xy'] = Vector2.ZERO
	state['budget'] = 32
	state['node'] = add_node(state.xy, str(state.budget))
	state['prev'] = null
	return state

class TreeNode:
	var xy    : Vector2 = Vector2.ZERO
	var wh    : Vector2 = Vector2.ONE
	var value : int = BFn.NONE
	var split : Array # the budgets passed to the children
	var count : int = 1
	var links : Array

	func _init(xy, value, split=[], nodes=[]):
		self.xy = xy
		self.value = value
		self.split = split
		self.links = nodes
		var shape = Vector2.DOWN
		for n in nodes:
			shape.x += n.wh.x
			shape.y = max(shape.y, 1+n.wh.y)
			self.count += n.count
		shape.x = max(1, shape.x) # always at least 1
		self.wh = shape

	func lo(): return links[0]
	func hi(): return links[1]

func sprout(trace, xy, budget):
	var res
	trace.append(['BUILD', {'xy':xy, 'b':budget}])
	if budget <= 2:
		var v = BFn.values()[rng.randi_range(0, BFn.I)]
		trace.append(['LEAF', {'xy':xy, 'v':v}])
		res = TreeNode.new(xy, v)
	else:
		var cut = 1 + rng.randi() % budget
		var split = [cut, budget-cut]
		var ops = [BFn.AND, BFn.OR, BFn.XOR]
		var bfn = ops[rng.randi_range(0,len(ops)-1)]
		trace.append(['SPLIT', {'v':bfn, 'split':split}])
		var cxy = xy+Vector2.DOWN # child xy
		trace.append(['LHS', {}])
		var lhs = sprout(trace, cxy,  split[0])
		trace.append(['END_LHS', {'n': lhs}])
		trace.append(['RHS', {}])
		var rhs = sprout(trace, cxy+lhs.wh.x * Vector2.RIGHT, split[1])
		trace.append(['END_RHS', {'n': rhs}])
		res = TreeNode.new(xy, bfn, split, [lhs, rhs])
	trace.append(['UP', {'n': res}])
	return res

const CELLSIZE = Vector2(48,48)
func animate(trace, tree):
	var stack = []; var gsn; var lo; var hi; var xy
	for step in trace:
		yield()
		print(step)
		var s = step[1]
		match step[0]:
			'BUILD':
				if gsn == null:
					xy = s['xy'] * CELLSIZE
					gsn = add_node(xy, str(s['b']))
			'LEAF':
				set_theme(gsn, s['v'])
				gsn.modulate = Color.white
			'SPLIT':
				var split = s['split']
				lo = add_node(xy + CELLSIZE * Vector2.DOWN, str(split[0]))
				hi = add_node(xy + CELLSIZE * Vector2.RIGHT, str(split[1]))
				add_edge(gsn, lo); add_edge(gsn, hi)
				set_theme(gsn, s['v'])
				gsn.modulate = DIM_NODE; hi.modulate = DIM_NODE
			'LHS':
				stack.push_back([gsn, lo, hi, xy, tree])
				xy = lo.rect_position - position
				gsn = lo; tree = tree.lo()
			'RHS':
				stack.push_back([gsn, lo, hi, xy, tree])
				xy = hi.rect_position - position
				gsn = hi; tree = tree.hi()
			'END_LHS':
				#draw_box(s['n'].xy, s['n'].wh, Color.goldenrod)
				hi.rect_position = position + (tree.hi().xy * CELLSIZE)
			'END_RHS':
				# center the gsn between the two branches
				#draw_box(s['n'].xy, s['n'].wh, Color.cornflower)
				var cx = (tree.lo().wh.x + tree.hi().wh.x) * CELLSIZE.x/2
				gsn.rect_position += Vector2.RIGHT * cx
			'UP':
				if stack.size():
					var p = stack.pop_back()
					gsn=p[0]; lo=p[1]; hi=p[2]; xy=p[3]; tree=p[4]
					gsn.modulate = Color.white

func set_theme(node, key):
	var theme = THEME[BFn.keys()[key]]
	# shape, textcolor, bgcolor, text
	node.shape = theme[0]
	node.text_color = theme[1]
	node.fill_color = theme[2]
	node.text = theme[3]

func draw_box(xy, wh, color):
	var box = add_node(xy * CELLSIZE, '')
	box.shape = GsNode.SHAPE.RECT
	box.rect_size = wh * CELLSIZE
	box.get_parent().move_child(box, 0)
	box.fill_color = Color.transparent
	box.line_color = color

func add_node(xy:Vector2, text:String)->GsNode:
	var node = GsNode.new()
	node.rect_position = position + xy
	node.text = text
	node.rect_min_size = 32 * Vector2.ONE
	node.shape = GsNode.SHAPE.DISK
	GsLib.add_node(node)
	GsLib.app.selection = []
	return node

func add_edge(a:GsNode, b:GsNode):
	var curve = Curve2D.new()
	curve.add_point(Vector2.ZERO)
	curve.add_point(b.link_point(0) - a.link_point(0))
	var edge = GsEdge.new()
	edge.modulate = Color(0xffffff11)
	edge = GsEdge.new(); edge.curve = curve
	edge.rect_position = a.link_point(0)
	GsLib.add_edge(a, b, edge)
