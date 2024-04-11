extends Node

class_name Ranking


var game_id = ''
var user_name = ''
var score: int = 0
var date = ''

const FILLABLE = ['game_id', 'user_name', 'score', 'date']

func _init(_data) -> void:
    game_id = _data.game_id if 'game_id' in _data else ''
    user_name = _data.user_name if 'user_name' in _data else ''
    score = _data.score if 'score' in _data else 0
    
    # 現在時刻
    var now = Time.get_datetime_dict_from_system()
    var now_format = "%04d-%02d-%02d %02d:%02d"%[now["year"], now["month"], now['day'], now['hour'], now['minute']] 
    date = now_format

func get_postable():
    var postable_data = {}
    for key in FILLABLE:
        if key in self:
            postable_data[key] = self[key]
    return postable_data
