class_name GsMouseTool extends Reference
func get_class_name(): return "GsMouseTool"

var sketch : GsSketch

func _ready(): _start()
func _start(): pass
func _name()->String: return self.get_class_name()
func _click(_mouse:GsMouse): pass
func _drag_start(_mouse:GsMouse): pass
func _drag_step(_mouse:GsMouse): pass
func _drag_end(_mouse:GsMouse): pass
