@tool extends PanelContainer

var o : GsBase = null: set = set_item

func set_item(x: GsBase):
	o = x
	if o != null:
		if 'fill_color' in o: $vbox/fill_color/ColorPickerButton.color = o.fill_color
		if 'line_color' in o: $vbox/line_color/ColorPickerButton.color = o.line_color
		if 'text_color' in o: $vbox/text_color/ColorPickerButton.color = o.text_color
		if 'shape' in o:  $vbox/shape/shape_picker.selected = o.shape
		if 'text' in o: $vbox/text.text = o.text
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
