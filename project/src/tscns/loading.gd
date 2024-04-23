extends Control

var loading_text = "Loading"
var animation_index:int = 0    

func _ready() -> void:
    $Label.text = loading_text

func _on_timer_timeout() -> void:
    animation_index += 1
    
    if animation_index > 3:
        animation_index = 0
    var dots = ''
    for dot in animation_index:
        dots += '.'
    $Label.text = loading_text + dots
