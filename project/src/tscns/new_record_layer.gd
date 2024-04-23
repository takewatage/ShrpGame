extends CanvasLayer


# -----------------------------------------------
#signal.
# -----------------------------------------------
signal ranking_update()

# -----------------------------------------------
# const.
# -----------------------------------------------


# -----------------------------------------------
# export.
# -----------------------------------------------


# -----------------------------------------------
# variable
# -----------------------------------------------


# -----------------------------------------------
# onready.
# -----------------------------------------------
@onready var _varidation_text = $ColorRect/ValidationLabel
@onready var _text_input = %NameForm

# -----------------------------------------------
# function
# -----------------------------------------------

func _ready() -> void:
    $ColorRect/ScoreLabel.text = 'SCORE: ' + str(Common.score)
    
## バリデーション
func _validate():
    var is_valid = false
    if not _text_input.text.length():
        is_valid = true
        _varidation_text.text = '名前は必須です'
        
    else:
        is_valid = false
        _varidation_text.text = ''
    
    return is_valid

func _on_ok_button_button_pressed() -> void:
      
    var valid = _validate()
    if valid:
        return
        
    var ranking_model = Ranking.new({
        'game_id': Common.game_id,
        'user_name': _text_input.text,
        'score': Common.score,
    })
    
    $Loading.show()
    await FirebaseService.remove_ranking()
    await FirebaseService.add_ranking(ranking_model)
    $Loading.hide()
    ranking_update.emit()
    
    queue_free()

func _on_close_button_pressed() -> void:
    queue_free()
