extends ScrollContainer

export var sample : AudioStreamSample setget _set_sample,_get_sample
export var start  : float = 0.0
export var end    : float = 0.0
export var head   : float = 0.0 setget _set_head

onready var clipNode = $ClipContainer/AudioClip
onready var headNode = $ClipContainer/PlayHead

var playing = false
var mix_rate = 44100
export var timeScale = 128

func _set_sample(x):
	start = 0.0
	self.head = start
	end = 0.0 if x == null else x.get_length()
	mix_rate = 44100 if x == null else x.mix_rate
	clipNode.sample = x

func _get_sample():
	return clipNode.sample

func _set_head(x):
	head = x
	headNode.rect_position.x = timeToPixels(x)

func play():
	self.head = start
	self.playing = true
	$AudioStreamPlayer.stream = clipNode.sample
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")

func timeToPixels(t):
	return t * (mix_rate / timeScale)

func _process(dt):
	if playing:
		self.head += dt
		if self.head > self.end:
			playing = false
