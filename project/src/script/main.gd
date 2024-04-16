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
## utility 
const uuid_util = preload('res://addons/uuid/uuid.gd')

# -----------------------------------------------
# onready.
# -----------------------------------------------
@onready var _ranking_scene = preload('res://src/tscns/menu/ranking_window.tscn')
# CanvasLayer.
@onready var _wall_layer = $WallLayer
@onready var _item_layer = $ItemLayer
@onready var _ranking_layer = $RankingLayer
#@onready var _particle_layer = $ParticleLayer
@onready var _ui_layer = $UILayer
@onready var _ui_score = $UILayer/Score
@onready var _ui_hi_score = $UILayer/HiScore
# -----------------------------------------------
# variable
# -----------------------------------------------
var now_item_id #現在のitemのID
var next_item_id = NEXT_ITEMS_TABLE.pick_random() #次のitemのID

func _ready():
    
    # レイヤーテーブル.
    var layers = {
        "wall": _wall_layer,
        "item": _item_layer,
        #"particle": _particle_layer,
        "ui": _ui_layer,
    }
    Common.set_game_id(uuid_util.v4())
    # セットアップ.
    Common.setup(layers)
    
    change_image()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    #$SelectItem.position = $Player.position
    $StrikeController.target_vector = $SelectItem.position
    
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
    
## nextとselect画像を変更
func change_image():
    now_item_id = next_item_id
    next_item_id = NEXT_ITEMS_TABLE.pick_random()
    
    $SelectItem.show()
    
    var texture = load(Item.TEXTURES[now_item_id])
    var nextTexture = load(Item.TEXTURES[next_item_id])
    $SelectItem.set_texture(texture)
    $NextItem.set_texture(nextTexture)
    
# UI更新
func updateUi(_delta:float) -> void:
    # スコア更新.
    _ui_score.text = "SCORE: %d"%Common.score
    _ui_hi_score.text = "HI-SCORE: %d"%Common.hi_score
    
# マージエフェクト
func popPartical(pos) -> void:
    $Particles_star.position = pos
    $Particles_star.set_deferred("emitting", true)

# システム音
func playSE(_sound) -> void:
    $SE.stop()
    $SE.stream = _sound
    $SE.play()
    
# ゲームオーバー処理
func gameOver() -> void:
    if Common.game_status != Common.GAME_STATUS.GAME_OVER:
        print('gameOver')
        Common.game_status = Common.GAME_STATUS.GAME_OVER
        $SelectItem.hide()
        $GameOverLayer.show()
        $GameOverLayer/Anim.play("gameOverAnimation")
        $UILayer/PoseBtn.hide()
        $StrikeController.setControll(false)
        # アイテムを全部落とす
        get_tree().call_group("items", "jumpOut")
        
        if Common.update_hi_score:
            # ハイスコア更新
            UserSetting.set_value("hiscore", Common.hi_score)

# ポーズ
func _on_pose_btn_pressed() -> void:
    Common.gamePose()
    $Menu.show()
    $ItemLayer.hide()
    
# ポーズ後の開始
func _on_menu_play_start() -> void:
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
func _on_title_button_button_pressed() -> void:
    Common.set_game_id(null)
    Common.goto_scene("res://src/tscns/Title.tscn")

## ランキング表示
func _on_go_ranking_button_button_pressed() -> void:
    var _ranking_instance = _ranking_scene.instantiate()
    _ranking_layer.add_child(_ranking_instance)
    _ranking_instance._show()
