extends Node2D

@onready var animate = $Control/TextureButton/AnimationPlayer
@onready var audio = $Control/AudioStreamPlayer2D
var _settingMenu = preload('res://src/tscns/menu/setting_menu.tscn')

func _ready():
	pass


func _process(_delta):
	pass


func _on_texture_button_pressed():
	animate.play("on_button")
	audio.play()
	await get_tree().create_timer(0.5).timeout
	Common.goto_scene("res://game.tscn")



func _on_setting_btn_button_pressed() -> void:
	var setingMenu = _settingMenu.instantiate()
	add_child(setingMenu)
	setingMenu._show()
	
