extends Node

# ===============================================
# 共通スクリプト.
# ===============================================

# ===============================================
# const
# ===============================================
const TIMER_ITEM_APPEAR = 1.0

# -----------------------------------------------
# preload.
# -----------------------------------------------
## ITEMテーブル.
const ITEM_TBL = {
	Item.eItem.WORDPRESS: preload("res://src/items/wordpress.tscn"),
	Item.eItem.JS: preload("res://src/items/js.tscn"),
	Item.eItem.VUE: preload("res://src/items/vue.tscn"),
	Item.eItem.FIGMA: preload("res://src/items/figma.tscn"),
	Item.eItem.DOCKER: preload("res://src/items/docker.tscn"),
	Item.eItem.PHP: preload("res://src/items/php.tscn"),
	Item.eItem.LARAVEL: preload("res://src/items/laravel.tscn"),
	Item.eItem.REACTNATIVE: preload("res://src/items/reactnative.tscn"),
	Item.eItem.MYSQL: preload("res://src/items/mysql.tscn"),
	Item.eItem.SHRP: preload("res://src/items/shrp.tscn"),
}

# -----------------------------------------------
# var.
# -----------------------------------------------
## CanvasLayer.
var _layers = {}
## スコア.
var score:int = 0
## ハイスコア.
var hi_score:int = 0
## 表示用加算スコア.
var disp_add_score:int = 0


# -----------------------------------------------
# function
# -----------------------------------------------
## シーンの切り替え
func goto_scene(scene_path):
	call_deferred("_deferred_goto_scene", scene_path)

func _deferred_goto_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)

## セットアップ.
func setup(layers) -> void:
	# スコア初期化.
	score = 0
	_layers = layers
	
## @param is_deferred 遅延生成するかどうか.
## particle_pos: スコアパーティクルを生成するときの座標
func createItem(id:Item.eItem , is_deferred:bool=false, particle_pos:Vector2=Vector2.ZERO) -> Item:

	# PackedSceneを取得.
	var packed = ITEM_TBL[id]
	var item = packed.instantiate()
	var layer = getLayer("item")
	if is_deferred:
		layer.call_deferred("add_child", item)
		# スコア加算.
		var _score = addScore(id)
		# スコア演出生成.
		#ParticleUtil.add_score(particle_pos, score)
		# 表示用加算スコア.
		disp_add_score += _score
	else:
		layer.add_child(item)
	
	return item

## レイヤーの取得.
func getLayer(layer_name:String) -> CanvasLayer:
	return _layers[layer_name]
	
## スコア加算.
## @return 加算したスコアの値.
func addScore(id:Item.eItem) -> int:
	# Σ(n-1)
	var v = 0
	for i in range(id, 0, -1):
		v += i
	score += v
	if score > hi_score:
		hi_score = score
	
	return v

## 壁の当たり判定をなくす
func disableAllChildren():
	var layer = getLayer("wall")
	print(layer.get_children())
	for child in layer.get_children():
		child.queue_free()
	
## ポーズ
func gamePose():
	var tree = get_tree()
	if tree:
		# ポーズ開始。ゲームを止める
		tree.paused = true
	
## ポーズ解除
func gameResume():
	var tree = get_tree()
	if tree:
		# ポーズ解除
		tree.paused = false
