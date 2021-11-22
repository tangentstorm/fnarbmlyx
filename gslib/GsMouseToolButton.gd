extends ToolButton

export (Script) var tool_script = load('res://gslib/GsMouseTool.gd')

func _ready():
	self.connect('pressed', self, '_click')
	
func _click():
	var m : GsMouse = get_node("/root/app/mouse")
	m.set_tool_script(tool_script)
