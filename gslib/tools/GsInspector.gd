tool extends PanelContainer

var o : GsBase = null: set = set_item

func set_item(x: GsNode):
	o = x
	if o != null:
		$vbox/fill_color/ColorPickerButton.color = o.fill_color
		$vbox/line_color/ColorPickerButton.color = o.line_color
		$vbox/text_color/ColorPickerButton.color = o.text_color
		$vbox/shape/shape_picker.selected = o.shape
		$vbox/text.text = o.text
		$vbox/info/label.text = o.get_info()


func _on_text_color_changed(color):
	if o!=null: o.text_color = color

func _on_fill_color_changed(color):
	if o!=null: o.fill_color = color

func _on_line_color_changed(color):
	if o!=null: o.line_color = color

func _on_text_changed(new_text):
	if o!=null: o.text = new_text

func _on_shape_picker_item_selected(index):
	if o!=null: o.shape = index



func _on_inspector_mouse_entered():
	GsLib.app.ignore_mouse += 1

func _on_inspector_mouse_exited():
	GsLib.app.ignore_mouse -= 1
