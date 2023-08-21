tool class_name GsGroup extends GsBase
func get_class_name(): return 'GsGroup'

func add_item(x):
	$members.add_child(x); x.set_owner(self.owner)

func _drag_step(dxy):
	# we need nodes to share the global coordinate system,
	# even though they are in our relative space. therefore,
	# every time we adjust the group's position,
	# we offset $members in the opposite direction.
	position += dxy
	$members.position -= dxy
	for c in $members.get_children(): c._drag_step(dxy)

func ungroup()->Array:
	var p = get_parent()
	var res = $members.get_children()
	for c in res:
		$members.remove_child(c)
		p.add_child(c); c.set_owner(p)
	queue_free()
	return res

func set_selected(v):
	super.set_selected(v)
	if $drag_helper:
		$drag_helper.color = Color('60215dc3') if v else Color.TRANSPARENT
