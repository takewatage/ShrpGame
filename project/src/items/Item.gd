extends RigidBody2D

class_name Item

## 種類.
## 進化テーブル
enum eItem {
	WORDPRESS,
	JS,
	VUE,
	FIGMA,
	DOCKER,
	PHP,
	LARAVEL,
	REACTNATIVE,
	MYSQL,
	SHRP,
}

## 名前テーブル.
const NAMES = {
	eItem.WORDPRESS: "Wordpress",
	eItem.JS: "Js",
	eItem.VUE: "Vue",
	eItem.FIGMA: "Figma",
	eItem.DOCKER: "Docker",
	eItem.PHP: "Php",
	eItem.LARAVEL: "Laravel",
	eItem.REACTNATIVE: "Reactnative",
	eItem.MYSQL: "Mysql",
	eItem.SHRP: "Shrp",
}

## テクスチャテーブル.
const TEXTURES = {
	eItem.WORDPRESS: "res://assets/images/items/item1.png",
	eItem.JS: "res://assets/images/items/item2.png",
	eItem.VUE: "res://assets/images/items/item3.png",
	eItem.FIGMA: "res://assets/images/items/item4.png",
	eItem.DOCKER: "res://assets/images/items/item5.png",
	eItem.PHP: "res://assets/images/items/item6.png",
	eItem.LARAVEL: "res://assets/images/items/item7.png",
	eItem.REACTNATIVE: "res://assets/images/items/item8.png",
	eItem.MYSQL: "res://assets/images/items/item9.png",
	eItem.SHRP: "res://assets/images/items/item10.png",
}

# -----------------------------------------------
# export.
# -----------------------------------------------
## アイテムID
@export var id:eItem
## スコア
@export var score:int

@export var nextItem: PackedScene

var is_check = false  # 判定中のフラグ
var has_exited_viewport = false # 画面内にあるか


# Called when the node enters the scene tree for the first time.
func _ready():
	print(NAMES[id])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_just_pressed("gran_command"):
		grandCommand()
		
	
	if !has_exited_viewport and isOffScreen():
		has_exited_viewport = true
		print("画面外")
		get_parent().call_deferred("gameOver")
		queue_free()
	

# 判定中か	
func isChecked():
	return is_check
	
# 判定開始
func setCheked():
	is_check = true

## 当たった時
func _on_body_entered(body: Node) -> void:

	if not body is Item:
		return 
		
	if self.is_queued_for_deletion():
		return # すでに破棄要求されている.
	if body.is_queued_for_deletion():
		return # すでに破棄要求されている.

	# ヒットした.
	var other = body as Item
	
	if id != other.id:
		return # 一致していないので何も起こらない.
		
	# IDが一致していたら合成可能.
	if id < eItem.SHRP:
		# 中間地点
		var pos = (position + other.position) / 2
		var is_deferred = true
		var item = Common.createItem(id + 1, is_deferred, pos)
		item.position = pos
		get_parent().call_deferred("popPartical", pos)
	else:
		return
		
	# お互いに消滅する.
	queue_free()
	other.queue_free()
	
# 画面外判定
func isOffScreen() -> bool:
	var _global_position = get_global_position()
	var viewport_rect = get_viewport_rect()
	return !viewport_rect.has_point(_global_position)

# 大号令
func grandCommand() -> void: 
	#print($CollisionShape2D.disabled)
	pass
	
	#print('大号令')
	#apply_central_impulse(Vector2(0, 10000))
	#apply_torque_impulse(30000)
	
# クリア後の挙動
func jumpOut() -> void:
	print("jumpOut----")
	var bottol_center = Vector2(360, 640)
	var force_direction = (position - bottol_center).normalized()
	
	var shot_speed = 250.0
	var shot_force = shot_speed * force_direction
	

	for child in Common.getLayer('wall').get_children():
		if child.is_class("RigidBody2D"):
			var collision_shape = child.get_node("CollisionShape2D")
			if collision_shape:
				collision_shape.set_deferred('disabled', true)
				
	apply_central_impulse(shot_force)

	#$CollisionShape2D.set_deferred('disabled', true)
	
	
	




