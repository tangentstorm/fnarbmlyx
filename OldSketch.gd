# old sketch concept. used physics engine example from:
# https://kidscancode.org/godot_recipes/physics/rigidbody_drag_drop/
extends Node2D

var held_obj = null

func _ready():
	for child in self.get_children():
		child.connect('mbld', self, "_on_grab")


func _on_grab(x):
	if !held_obj:
		held_obj = x
		x.grab()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if held_obj and !event.pressed:
				held_obj.drop()
				held_obj=null
		if event.button_index == BUTTON_WHEEL_UP:
			scale *= 1.1
			# position += get_local_mouse_position() *1.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			scale /= 1.1
			# position -= get_local_mouse_position()/1.1
