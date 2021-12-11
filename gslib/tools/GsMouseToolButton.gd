tool extends ToolButton

export (Script) var tool_script = load('res://gslib/tools/GsMouseTool.gd')

func _ready():
	self.connect('pressed', self, '_click')
	
func _click():
	GsLib.mouse.set_tool_script(tool_script)
