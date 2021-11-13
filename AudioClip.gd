extends ColorRect

# draw audio clips
# samples are in pcm format
# pcm = pulse code modulation.
# pulse code = amplitude as 8 or 16 bit number
# data format is array of alternating (left sample, right sample) values

export var sample : AudioStreamSample = null setget _set_sample
export var timeScale : int = 128
var bytesPerSample: int

var offSet = 0

func _set_sample(x):
	sample = x
	offSet = 0
	bytesPerSample = _bytesPerSample()

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func _bytesPerSample():
	var bytes = [1,2,0][sample.format]
	if sample.stereo: bytes <<= 1
	return bytes

func sampleFormat():
	var f = ["FORMAT_8_BITS", "FORMAT_16_BITS", "FORMAT_IMA_ADPCM"]
	return f[sample.format]

func printSampleInfo():
	print("format:", sampleFormat())
	print("mix rate:", sample.mix_rate)
	print("stereo?:", sample.stereo)
	print("length (seconds):", sample.get_length())
	print("size(bytes):", sample.data.size())
	print("bytes per sample:", bytesPerSample)
	var s = sample
	var t = (1.0*s.data.size()) / (bytesPerSample*s.mix_rate)
	assert(abs(s.get_length() - t) < 0.000001)

func getStereoSample16(i):
	# help from: https://godotengine.org/qa/67091/how-to-read-audio-samples-as-1-1-floats
	var d = sample.data # ; var j =  i + 2
	var a = (((d[i] | (d[i+1]<<8)) + 32768)  & 0xffff) - 32768
	return a # draw left channel only
	# var b = (((d[j] | (d[j+1]<<8)) + 32768)  & 0xffff) - 32768
	# return (a+b)>>1

func _process(_dt):
	pass
	#if sample and t < sample.data.size():
	#	update()

func _draw():	
	if sample:
		printSampleInfo()
		var o = Vector2(0,rect_size.y/2)
		var pen = o + Vector2.ZERO
		for x in range(rect_size.x):
			var i = timeScale*(offSet+x) * bytesPerSample
			if i >= sample.data.size(): break
			var v = getStereoSample16(i)/32768.0 * (rect_size.y /2)
			var next = o + Vector2(x, v)
			draw_line(pen, next, Color.black)
			pen = next
		# offSet += rect_size.x / 2  # auto-scroll
