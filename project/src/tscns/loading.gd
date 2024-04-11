extends AnimatedSprite2D

var loading = false

func set_loading(bool) -> void:
    if bool:
        show()
        self.play('gif')
    else:
        self.stop()
        hide()
