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
# variable.
# -----------------------------------------------
## ミュート
var mute_enabled = not UserSetting.get_value('musicvolume_enabled')

# -----------------------------------------------
# function.
# -----------------------------------------------
func _ready():
	print('volume:' + str(UserSetting.get_value('musicvolume')))
	print('mete:' + str(UserSetting.get_value('musicvolume_enabled')))
	$BgmVolume.value = UserSetting.get_value('musicvolume')

func _process(_delta):
	pass

# スタートボタン
func _on_play_btn_button_pressed():
	Common.gameResume()
	playStart.emit()
	hide()

# リスタートボタン
func _on_re_start_btn_button_pressed():
	Common.gameResume()
	Common.goto_scene("res://src/tscns/Title.tscn")

# ボリューム調整
func _on_bgm_volume_value_changed(vol: float) -> void:
	
	if vol <= -10:
		print('ミュート')
		mute_enabled = true
		UserSetting.set_value("musicvolume_enabled", false)
	elif mute_enabled:
		print('ミュート解除')
		mute_enabled = false
		UserSetting.set_value("musicvolume_enabled", true)
	
	UserSetting.set_value('musicvolume', vol)
