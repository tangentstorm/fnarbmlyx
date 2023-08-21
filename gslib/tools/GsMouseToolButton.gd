@tool extends Button

@export var tool_script : Script = load('res://gslib/tools/GsMouseTool.gd')

func _ready():
	self.connect('pressed', Callable(self, '_click'))
	
func _click():
	GsLib.mouse.set_tool_script(tool_script)
