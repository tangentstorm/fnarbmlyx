class_name GsMouseTool extends Node
func get_class_name(): return "GsMouseTool"

var sketch : GsSketch

func _ready(): _start()
func _start(): pass
func _name()->String: return self.get_class_name()
func _click(mouse:GsMouse): pass
func _drag_start(mouse:GsMouse): pass
func _drag_step(mouse:GsMouse): pass
func _drag_end(mouse:GsMouse): pass
