extends Node2D

# ===============================================
# テスト用
# ===============================================

@onready var strikeController = $StrikeArea2D

const strikeBodyTscn = preload("res://src/items/strikeBody.tscn")
var strikeBody: Node

## 状態.
var is_striked = false
## 停止とみなす速度の閾値
var epsilon = 2
## 四体フラグ
var is_four = false
## 大号令フラグ
var is_grond = false

# Called when the node enters the scene tree for the first time.
func _ready():
	strikeBody = strikeBodyTscn.instantiate()
	add_child(strikeBody)
	strikeBody.position = Vector2(360, 360)
	strikeBody.add_to_group("strikes")
	strikeController.setControll(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SetButton.set_text('4体:' + str(is_four))
	$SetButton2.set_text('大号令:' + str(is_grond))
	strikeController.target_vector = strikeBody.position
	if is_striked:
		if strikeBody.get_linear_velocity().length() < epsilon and strikeBody.get_angular_velocity() < epsilon:
			# 速度が閾値以下になったら停止とみなす
			strikeBody.set_linear_velocity(Vector2.ZERO)
			is_striked = false
			# 止まったところから矢印が出るように
			strikeController.target_vector = strikeBody.position
			strikeController.setControll(true)


func _on_set_button_pressed():
	is_four = !is_four
	if is_four:
		for i in range(3):
			var body = strikeBodyTscn.instantiate()
			body.position = Vector2(30 * i, 400)
			add_child(body)
			body.add_to_group("strikes")
		

## ショット
func _on_strike_area_2d_shot(force):
	if !is_striked:
		strikeController.setControll(false)
		if is_grond:
			var objects_in_group = get_tree().get_nodes_in_group("strikes")
			for object in objects_in_group:
				if object is RigidBody2D:
					object.apply_central_impulse(force)
		else:
			strikeBody.apply_central_impulse(force)
		await get_tree().create_timer(0.5).timeout
		is_striked = true
	
	


func _on_set_button_2_pressed():
	is_grond = !is_grond
	var objects_in_group = get_tree().get_nodes_in_group("strikes")
	print(objects_in_group)
