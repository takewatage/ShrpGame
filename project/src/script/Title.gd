extends Node2D

@onready var animate = $Control/TextureButton/AnimationPlayer


func _ready():
	pass # Replace with function body.


func _process(_delta):
	pass


func _on_texture_button_pressed():
	animate.play("on_button")
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.5).timeout
	Common.goto_scene("res://game.tscn")

