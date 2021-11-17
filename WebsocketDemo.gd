class_name WebSocketDemo
tool extends VBoxContainer

var ws : WebSocketClient = WebSocketClient.new()

export var url : String = "ws://localhost:8081" setget _set_url
export var msg : String = "+/\\ p: i. 10" setget _set_msg

func _set_msg(v:String):
	$sentence/editSentence.text = v

func _set_url(v:String):
	if v.begins_with("ws://"):
		url = v
		if is_inside_tree(): $server/editServer.text = v
	else:
		var error = "websocket url should start with ws://"
		if is_inside_tree(): echo(error)
		else: assert(false, error)

func _ready():
	$output.text = "WebSocketDemo is ready!"
	ws.connect("connection_established", self, "_on_ws_connect")
	ws.connect("connection_error", self, "_on_ws_closed")
	ws.connect("connection_closed", self, "_on_ws_closed")
	ws.connect("data_received", self, "_on_ws_data")

func _process(_dt):
	ws.poll()

func echo(s:String):
	$output.text += s + "\n"

# -- websocket events ----------------------

func _on_ws_connect():
	echo("connected")	

func _on_ws_closed():
	echo("closed")

func _on_ws_data():
	echo(ws.get_peer(1).get_packet().get_string_from_utf8())
	

# -- ui events -----------------------------

func _on_btnConnect_pressed():
	ws.connect_to_url(url)

func _on_btnDisconnect_pressed():
	ws.disconnect_from_host()

func _on_btnSend_pressed():
	ws.get_peer(1).put_packet(msg.to_utf8())

func _on_editServer_text_changed(v):
	self.url = v

func _on_editSentence_text_changed(v):
	msg = v
