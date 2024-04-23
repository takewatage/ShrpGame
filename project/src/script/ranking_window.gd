extends "res://src/script/base_menu.gd"

# -----------------------------------------------
# const.
# -----------------------------------------------
const _ranking_item = preload('res://src/tscns/ranking_content.tscn')

## top10まで表示
const RANKING_NUM = 10

# -----------------------------------------------
# variable
# -----------------------------------------------
var ranking_data = []

# -----------------------------------------------
# onready.
# -----------------------------------------------
@onready var _ranking_layer = $TextureRect/ScrollContainer/MarginContainer/RankingContainer

# -----------------------------------------------
# function
# -----------------------------------------------

func _ready() -> void:
    ## signal
    ## 開いた時
    connect('open_window', _on_open_ranking)
    
func _process(_delta: float) -> void:
    pass

## windowが開いた時
func _on_open_ranking():
    if Common.game_id:
        $GameId.text = Common.game_id
    await get_tree().create_timer(0.5).timeout
    await _ranking_fetch()
        
    if _check_ranking():
        $NewRecordLayer.show()

func _on_name_form_text_submitted(new_text: String) -> void:
    print(new_text)
    
## クローズ
func _on_close_button_button_pressed() -> void:
    $AnimationPlayer.play('closeMenu')
    await get_tree().create_timer(0.5).timeout
    queue_free()
    
## ランキング取得
func _ranking_fetch():
    $Loading.show()
    get_tree().call_group('rankings', 'queue_free')
    ranking_data = await FirebaseService.get_ranking()
    $Loading.hide() 
    # データ表示
    for i in ranking_data:
        var ranking_item_instance = _ranking_item.instantiate()
        ranking_item_instance.ranking_name = i.user_name
        ranking_item_instance.ranking_score = str(i.score)
        _ranking_layer.add_child(ranking_item_instance)
    
## ランキングが更新できるか
func _check_ranking():
    
    if !Common.game_id:
        return false
    
    # ランキングに登録してなかったら更新
    if not ranking_data.any(func(x): return x.game_id == Common.game_id):
        # Top 10に空きがあれば更新
        if ranking_data.size() < RANKING_NUM:
            return true
        # 一つでもスコアが更新できていれば更新
        if ranking_data.any(func(x): return x.score < Common.score):
            return true
    
    return false

## ランキングが更新された時
func _on_new_record_layer_ranking_update() -> void:
     await _ranking_fetch()
