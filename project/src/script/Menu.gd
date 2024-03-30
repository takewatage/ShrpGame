extends Control

@onready var bgm = get


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# スタートボタン
func _on_play_btn_button_pressed():
	Common.gameResume()
	hide()
	
func setVolume(value):
	$BgmVolume.set_deferred('value', value)

# リスタートボタン
func _on_re_start_btn_button_pressed():
	print("re start")
	Common.gameResume()
	Common.goto_scene("res://src/tscns/Title.tscn")


## ボリューム調整
func _on_bgm_volume_value_changed(value):
	# 0〜100を -10.0〜10.0 に変換する
	#var vol = ((value - 50) / 100.0) * 20.0
	var vol = value
	if vol <= -10:
		vol = -80
	get_parent().call_deferred('setVolume', vol)
	
