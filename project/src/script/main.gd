extends Node

# -----------------------------------------------
# const.
# -----------------------------------------------
## 抽選用テーブル
const NEXT_ITEMS_TABLE = [
	Item.eItem.WORDPRESS,
	Item.eItem.JS,
	Item.eItem.VUE,
	Item.eItem.FIGMA,
]

# -----------------------------------------------
# onready.
# -----------------------------------------------
# CanvasLayer.
@onready var _wall_layer = $WallLayer
@onready var _item_layer = $ItemLayer
#@onready var _particle_layer = $ParticleLayer
@onready var _ui_layer = $UILayer
@onready var _ui_score = $UILayer/Score
@onready var _ui_hi_score = $UILayer/HiScore

# -----------------------------------------------
# variable
# -----------------------------------------------
var now_item_id #現在のitemのID
var next_item_id = NEXT_ITEMS_TABLE.pick_random() #次のitemのID

# Called when the node enters the scene tree for the first time.
func _ready():
	# レイヤーテーブル.
	var layers = {
		"wall": _wall_layer,
		"item": _item_layer,
		#"particle": _particle_layer,
		"ui": _ui_layer,
	}
	# セットアップ.
	Common.setup(layers)
	$BGM.play()
	
	change_image()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SelectItem.position = $Player.position
	$StrikeController.target_vector = $Player.position
	
	if $SelectItem.visible:
		if !$GameOverLayer.visible:
			# 引っ張れるようにする
			$StrikeController.setControll(true)
			#drop()
			#await get_tree().create_timer(0.5).timeout
			#change_image()
		
				
	# UIの更新.
	updateUi(delta)
	
	if Input.is_action_just_pressed("gran_command"):
		Common.disableAllChildren()
	
	
func drop():
	var dropItem = Common.ITEM_TBL[now_item_id].instantiate()
	add_child(dropItem)
	dropItem.position = $SelectItem.position
	$SelectItem.hide()

func change_image():
	now_item_id = next_item_id
	next_item_id = NEXT_ITEMS_TABLE.pick_random()
	
	$SelectItem.show()
	
	var texture = load(Item.TEXTURES[now_item_id])
	var nextTexture = load(Item.TEXTURES[next_item_id])
	$SelectItem.set_texture(texture)
	$NextItem.set_texture(nextTexture)
	
func updateUi(_delta:float) -> void:
	# スコア更新.
	_ui_score.text = "SCORE: %d"%Common.score
	_ui_hi_score.text = "HI-SCORE: %d"%Common.hi_score
	
# マージエフェクト
func popPartical(pos) -> void:
	$Particles_star.position = pos
	$Particles_star.set_deferred("emitting", true)
	
# ゲームオーバー処理
func gameOver():
	$SelectItem.hide()
	$GameOverLayer.show()
	$GameOverLayer/Anim.play("gameOverAnimation")
	$UILayer/PoseBtn.hide()
	$StrikeController.setControll(false)
	# アイテムを全部落とす
	get_tree().call_group("items", "jumpOut")

# ポーズ
func _on_pose_btn_pressed():
	Common.gamePose()
	$Menu.show()
	$ItemLayer.hide()
	$Menu.setVolume($BGM.volume_db)
	
# ポーズ後の開始
func _on_menu_play_start():
	$ItemLayer.show()


func _on_strike_controller_shot(force) -> void:
	var dropItem = Common.ITEM_TBL[now_item_id].instantiate()
	add_child(dropItem)
	dropItem.position = $SelectItem.position
	$SelectItem.hide()
	# ショット
	dropItem.apply_central_impulse(force)
	
	# ショットした後にインターバルを儲ける
	await get_tree().create_timer(0.5).timeout
	change_image()

## タイトルに戻る
func _on_title_button_button_pressed():
	Common.goto_scene("res://src/tscns/Title.tscn")
	
	
func setVolume(_vol):
	$BGM.volume_db = _vol
	
