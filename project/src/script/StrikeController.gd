extends Area2D

signal shot

# -----------------------------------------------
# const.
# -----------------------------------------------
## 左クリックID
const BUTTON_LEFT = 1

# -----------------------------------------------
# export.
# -----------------------------------------------
## 弾く力
@export var STRIKE_FORCE = 1000
## 弾くターゲットの座標
@export var target_vector: Vector2
## コントロールできるか
@export var is_controll: bool

# -----------------------------------------------
# onready.
# -----------------------------------------------
@onready var arrow = $Arrow

# -----------------------------------------------
# variable
# -----------------------------------------------
## ドラッグ中か
var is_dragging = false
## ドラッグ開始位置
var drag_start_position = Vector2.ZERO

# -----------------------------------------------
# function
# -----------------------------------------------
func _ready():
	pass
	

func _process(_delta):
	pass

func _input(event):
	if is_controll:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				start_drag(event.global_position)
			elif is_dragging:
				is_dragging = false
				end_drag(event.global_position)
		
		# ドラッグ中の場合
		if is_dragging:
			dragging(event.global_position)	

# ドラッグ開始
func start_drag(position):
	drag_start_position = position
	arrow.set_position(target_vector)
	arrow.show()
	arrow.scale.y = 0
	
# ドラッグ中
func dragging(position):
	
	## 開始位置に戻したら矢印を消す
	if isClose(position, drag_start_position):
		arrow.hide()
	else:
		arrow.show()
	
	# ドラッグした方向と距離取得
	var drag_vector = (position - drag_start_position)
	var drag_distance = position.distance_to(drag_start_position)
	
	# 矢印から引っ張ったと仮定した座標を求める
	var dragging_position = arrow.position - drag_vector * drag_distance
	var vector_to_arrow = dragging_position - arrow.position
	
	# 矢印がデフォルトで上向きのため、90度回転させる
	arrow.rotation = vector_to_arrow.angle() + PI / 2
	arrow.scale.y = drag_vector.length() / arrow.texture.get_height()
	
	
#ドラッグ終了
func end_drag(position):
	var drag_end_position = position
	arrow.hide()
	
	# 矢印を元に戻したら何もしない
	if isClose(position, drag_start_position):
		return
		
	# 離したした方向と距離計算
	var drag_vector = (drag_end_position - drag_start_position).normalized()
	var drag_distance = drag_end_position.distance_to(drag_start_position)
	
	# 物体から引っ張ったと仮定したドラッグ終了座標を求める
	var dragged_position = target_vector - drag_vector * drag_distance
	var monnsuto_vector = (dragged_position - target_vector).normalized()
	
	# 弾く力
	var force = monnsuto_vector * STRIKE_FORCE
	
	shot.emit(force)

## 位置が距離範囲よりも小さいか
# param threshold 距離範囲
func isClose(position1: Vector2, position2: Vector2, threshold: float = 20.0) -> bool:
	return position1.distance_to(position2) <= threshold
	
func setControll(value: bool) -> void:
	is_controll = value
	
func getControll() -> bool:
	return is_controll

