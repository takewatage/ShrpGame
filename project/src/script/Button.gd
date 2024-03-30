extends Control
signal button_pressed

@export var text = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton/Label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	$TextureButton/AnimationPlayer.play("on_button")
	await get_tree().create_timer(0.3).timeout
	button_pressed.emit()
