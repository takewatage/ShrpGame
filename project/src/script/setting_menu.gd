extends 'res://src/script/base_menu.gd'


@onready var music_volume_slider = $TextureRect/BgmVolume
@onready var _animation = $AnimationPlayer

## 初期表示
var initialised = false
## ミュート
var mute_enabled = not UserSetting.get_value('musicvolume_enabled')

func _ready() -> void:
    position = Vector2.ZERO
    music_volume_slider.value = UserSetting.get_value('musicvolume')
    print('volume:' + str(UserSetting.get_value('musicvolume')))
    print('mute:' + str(mute_enabled))
    
    # signal 設定
    $TextureRect/BackBtn.button_pressed.connect(_on_back_btn_pressed)

func _on_bgm_volume_value_changed(vol: float) -> void:
    # 初回に保存されるのを回避
    if !initialised:
        initialised = true
        return
    if vol <= -10:
        print('ミュート')
        mute_enabled = true
        UserSetting.set_value("musicvolume_enabled", false)
    elif mute_enabled:
        print('ミュート解除')
        mute_enabled = false
        UserSetting.set_value("musicvolume_enabled", true)
    
    UserSetting.set_value('musicvolume', vol)

func _on_back_btn_pressed():
    _animation.play('closeMenu')
    await get_tree().create_timer(0.5).timeout
    queue_free()
    
    
