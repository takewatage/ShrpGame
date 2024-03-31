extends Control

# -----------------------------------------------
# signal.
# -----------------------------------------------
signal playStart()

# -----------------------------------------------
# onready.
# -----------------------------------------------
@onready var bgm = get

# -----------------------------------------------
# function.
# -----------------------------------------------
func _ready():
	setVolume()

func _process(_delta):
	pass

# スタートボタン
func _on_play_btn_button_pressed():
	settingSave()
	Common.gameResume()
	playStart.emit()
	hide()
	
# ボリュームセット
func setVolume():
	$BgmVolume.set_deferred('value', Save.getSaveData("setting_volume"))

# リスタートボタン
func _on_re_start_btn_button_pressed():
	print("re start")
	settingSave()
	Common.gameResume()
	Common.goto_scene("res://src/tscns/Title.tscn")

# ボリューム調整
func _on_bgm_volume_value_changed(value):
	pass
	## ゲージが一番左(-10)の時は-100にして無音にする
	#var vol = value
	#if vol <= -10:
		#vol = -100
	#var setting = {
		#'setting_volume': vol
	#}
	#print(setting)
	#Save._save(setting)
	
# todo 設定保存
func settingSave():
	## ゲージが一番左(-10)の時は-100にして無音にする
	var setting = {
		'setting_volume': $BgmVolume.value if $BgmVolume.value > -10 else -100
	}
	print(setting)
	Save._save(setting)
	
