extends Control
signal button_pressed

@export var text = ''
@export var texture: Texture
@export var se_on: bool = true

func _ready():
    $TextureButton/HBoxContainer/Label.text = text
    $TextureButton/HBoxContainer/TextureRect.texture = texture
    
func _process(_delta):
    pass


func _on_texture_button_pressed() -> void:
    # 複数press対策
    $TextureButton.disabled = true
    $TextureButton/AnimationPlayer.play("on_button")
    if se_on:
        $PressSE.play()
    await get_tree().create_timer(0.1).timeout
    $TextureButton.disabled = false
    button_pressed.emit()
