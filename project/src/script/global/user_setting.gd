extends Node

signal on_value_change(key, value)

# -----------------------------------------------
# const.
# -----------------------------------------------
## セクション名
const SECTION = "user"
## 保存先
const SETTINGS_FILE = "user://settings.cfg"

## BGM
const MUSIC_VOLUME = 'musicvolume'
const MUSIC_VOLUME_ENABLED = 'musicvolume_enabled'
## SOUND EFFRCT
const SOUND_EFFECT_VOLUME = 'soundvolume'

## ハイスコア
const HI_SCORE = 'hiscore'

const AUDIO_BUS_MUSIC = 'Music'
const AUDIO_BUS_SE = 'SoundEffect'
const PLAYER_DATA = 'PlayerData'

# -----------------------------------------------
# export.
# -----------------------------------------------


# -----------------------------------------------
# variable
# -----------------------------------------------
## デフォルト設定
var USER_SETTING_DEFAULTS = {
    MUSIC_VOLUME: 0,
    SOUND_EFFECT_VOLUME: 0,
    MUSIC_VOLUME_ENABLED: true,
    HI_SCORE: 0,
}

var config:ConfigFile

# -----------------------------------------------
# onready.
# -----------------------------------------------

# -----------------------------------------------
# function
# -----------------------------------------------
func get_value(key):
    return config.get_value(SECTION, key, _get_default(key))
    
func set_value(key, value):
    config.set_value(SECTION, key, value)
    config.save(SETTINGS_FILE)
    
    if key == MUSIC_VOLUME:
        _update_volume(MUSIC_VOLUME, AUDIO_BUS_MUSIC)
    if key == SOUND_EFFECT_VOLUME:
        _update_volume(SOUND_EFFECT_VOLUME, AUDIO_BUS_SE)
    if key == MUSIC_VOLUME_ENABLED:
        _mute_bus(MUSIC_VOLUME_ENABLED, AUDIO_BUS_MUSIC)
    
    print("config save...")
    emit_signal("on_value_change", key, value)
    
## 値取得、なかったらデフォルトを返す
func get_value_with_default(key, default):
    return config.get_value(SECTION, key, default)


func _ready() -> void:
    config = ConfigFile.new()
    config.load(SETTINGS_FILE)
    _configure_audio()
    
## オーディオ更新
func _configure_audio():
    _update_volume(MUSIC_VOLUME, AUDIO_BUS_MUSIC)
    _mute_bus(MUSIC_VOLUME_ENABLED, AUDIO_BUS_MUSIC)
    
func _get_default(key):
    if USER_SETTING_DEFAULTS.has(key):
        return USER_SETTING_DEFAULTS[key]
    return null
    
func _update_volume(property, bus):
    # 現在の値取得
    var current = get_value_with_default(property, USER_SETTING_DEFAULTS[property])
    # 音量更新
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), current)

## ミュート設定
func _mute_bus(property, bus):
    var enabled = get_value_with_default(property, USER_SETTING_DEFAULTS[property])
    AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), not enabled)
