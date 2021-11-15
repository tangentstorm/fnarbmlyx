extends ScrollContainer

export var sample : AudioStreamSample setget _set_sample,_get_sample
export var start  : float = 0.0
export var end    : float = 0.0
export var head   : float = 0.0 setget _set_head
export var timeScale : int = 128 setget _set_timeScale, _get_timeScale
export var playerPath : NodePath #setget _set_playerPath

onready var clipNode = $ClipContainer/AudioClip
onready var headNode = $ClipContainer/PlayHead
onready var player = get_node(playerPath)

var playing = false
var mix_rate = 44100

func _set_timeScale(x):
	clipNode.timeScale = x

func _get_timeScale():
	return clipNode.timeScale

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
	if clipNode.sample == null: return
	if head >= end: head = start
	playing = true
	player.stream = clipNode.sample
	print("end is:", end)
	print("length is:", clipNode.sample.get_length())
	print("playing from ", head)
	player.play(head)
	yield(player, "finished")

func stop():
	self.playing = false
	player.stop()

func timeToPixels(t:float) -> float:
	return t * mix_rate / timeScale

func pixelsToTime(px:float) -> float:
	return px * timeScale / mix_rate

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		self.head = pixelsToTime(event.position.x - rect_position.x)

func _process(dt):
	if playing:
		self.head += dt
		if self.head > self.end:
			playing = false
