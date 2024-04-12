extends AnimatedSprite2D

var loading = false

func set_loading(_bool: bool) -> void:
    if _bool:
        show()
        self.play('gif')
    else:
        self.stop()
        hide()
