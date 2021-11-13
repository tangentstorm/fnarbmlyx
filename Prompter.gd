extends Node
# Prompter helps you record audio samples
# corresponding to text prompts.

export var root : String = "e:/audio/"
export var path : String = "lines"
export var cursor : int = 0
export var prompts : PoolStringArray = [
	"zero", "one", "two", "three", "four",
	"five", "six", "seven", "eight", "nine"]
var clips : Array = []
var paths : Array = []

func clearCards():
	for i in range(0, $vbox.get_child_count()):
		$vbox.get_child(i).queue_free()

func set_cursor(i):
	get_clip(cursor).active = false
	cursor = i
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
	set_cursor(0)

func save_clip(i=-1):
	if i == -1: i = cursor
	var s : AudioStreamSample = get_clip(i).sample
	s.save_to_wav(root + path + '/' + str(i))
