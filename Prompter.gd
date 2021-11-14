extends Node
# Prompter helps you record audio samples
# corresponding to text prompts.

export var root : String = "e:/audio/"
export var path : String = "lines"
export var cursor : int = 0 setget _set_cursor
export var prompts : PoolStringArray = [
	"zero", "one", "two", "three", "four",
	"five", "six", "seven", "eight", "nine"]
export var sample : AudioStreamSample setget _set_sample, _get_sample
var clips : Array = []
var paths : Array = []

func clearCards():
	for i in range(0, $vbox.get_child_count()):
		$vbox.get_child(i).queue_free()

func _get_sample():
	return get_clip(cursor).sample

func _set_sample(x):
	get_clip(cursor).sample = x

func _set_cursor(i):
	get_clip(cursor).active = false
	cursor = int(clamp(i, 0, prompts.size()-1))
	get_clip(cursor).active = true

func get_clip(i=-1):
	if i == -1: i = cursor
	return $vbox.get_child(i).get_node('clip')

func _ready():
	clearCards()
	for p in prompts:
		var c = $card.duplicate()
		c.visible = true
		c.get_node('prompt').text = p
		c.get_node('clip').sample = null # AudioStreamSample.new()
		$vbox.add_child(c)
	_set_cursor(0)

func save_clip(i=-1):
	if i == -1: i = cursor
	var s : AudioStreamSample = get_clip(i).sample
	s.save_to_wav(root + path + '/' + str(i))
