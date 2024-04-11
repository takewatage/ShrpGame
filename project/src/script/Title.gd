extends Node2D

@onready var animate = $Control/TextureButton/AnimationPlayer
@onready var audio = $Control/AudioStreamPlayer2D
var _settingMenu = preload('res://src/tscns/menu/setting_menu.tscn')
var _ranking_window = preload('res://src/tscns/menu/ranking_window.tscn')

func _ready():
    if FirebaseService.is_auth():
        $RankingBtn.show()
    else:
        var is_auth = await FirebaseService.login().login_success
        if is_auth:
            $RankingBtn.show()


func _process(_delta):
    pass


func _on_texture_button_pressed():
    animate.play("on_button")
    audio.play()
    await get_tree().create_timer(0.5).timeout
    Common.goto_scene("res://game.tscn")


## 設定表示
func _on_setting_btn_button_pressed() -> void:
    var setingMenu = _settingMenu.instantiate()
    add_child(setingMenu)
    setingMenu._show()
    

## ランキング表示
func _on_ranking_btn_button_pressed() -> void:
    print(Common.score)
    print(Common.game_id)
    var _ranking_window_instance = _ranking_window.instantiate()
    add_child(_ranking_window_instance)
    _ranking_window_instance.position = Vector2.ZERO
    _ranking_window_instance._show()
