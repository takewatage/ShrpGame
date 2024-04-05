extends Control

signal open_window

func _show():
	show()
	$AnimationPlayer.play('openMenu')
	open_window.emit()
