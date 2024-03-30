extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# スタートボタン
func _on_play_btn_button_pressed():
	print("play")
	Common.gameResume()
	hide()

# リスタートボタン
func _on_re_start_btn_button_pressed():
	print("re start")
	Common.gameResume()
	Common.goto_scene("res://src/tscns/Title.tscn")
