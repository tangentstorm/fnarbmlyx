extends Node2D

# project settings > audio > enable audio input

var mic
var clip

func _ready():
	var idx = AudioServer.get_bus_index("Record")
	print("idx: ", idx)
	mic = AudioServer.get_bus_effect(idx,0)
	print(mic)
	

func _process(_dt):
	if Input.is_action_just_pressed("ui_select"):
		mic.set_recording_active(true)
		print("recording!")
	if Input.is_action_just_released("ui_select"):
		print("recording active?", mic.is_recording_active())
		clip = mic.get_recording()
		mic.set_recording_active(false)
		print("done")
		print(clip.get_length())
		print(clip.data.size())
		var s:String = ""
		for i in range(0,100):
			s += str(clip.data[i])+" "
		print(s)
		
		$AudioStreamPlayer.stream = clip
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
		
