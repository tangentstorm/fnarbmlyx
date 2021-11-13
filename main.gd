extends Node2D

# project settings > audio > enable audio input

var mic
var clip : AudioStreamSample

func _ready():
	var idx = AudioServer.get_bus_index("Record")
	mic = AudioServer.get_bus_effect(idx,0)

func _process(_dt):
	if Input.is_action_just_pressed("ui_select"):
		mic.set_recording_active(true)

	if Input.is_action_just_released("ui_select"):
		clip = mic.get_recording()
		mic.set_recording_active(false)

		$AudioClip.sample = clip
		$AudioClip.update()

		$AudioStreamPlayer.stream = clip
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
