extends Node2D


# project settings > audio > enable audio input

var mic
var clip : AudioStreamSample

func _ready():
	var idx = AudioServer.get_bus_index("Record")
	mic = AudioServer.get_bus_effect(idx,0)


func _process(_dt):
	if Input.is_action_just_pressed("ui_record"):
		mic.set_recording_active(true)

	if Input.is_action_just_released("ui_record"):
		$ClipScroller.insert_sample(mic.get_recording())
		mic.set_recording_active(false)

	if Input.is_action_just_released("ui_save"):
		$Prompter.save_clip()

	if Input.is_action_just_released("ui_select"):
		if $ClipScroller.playing:
			$ClipScroller.stop()
			print("head stopped at:", $ClipScroller.head)
		else: $ClipScroller.play()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_UP:
			$Prompter.cursor -= 1
			$ClipScroller.sample = $Prompter.sample
		if event.scancode == KEY_DOWN:
			$Prompter.cursor += 1
			$ClipScroller.sample = $Prompter.sample
		if event.scancode == KEY_HOME:
			$ClipScroller.head = 0.0


func _on_ClipScroller_notify(sample):
	$Prompter.get_clip().sample = sample
