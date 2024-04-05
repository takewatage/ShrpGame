extends "res://src/script/base_menu.gd"

# -----------------------------------------------
# const.
# -----------------------------------------------
const _ranking_item = preload('res://src/tscns/ranking_content.tscn')

# -----------------------------------------------
# export.
# -----------------------------------------------


# -----------------------------------------------
# variable
# -----------------------------------------------


# -----------------------------------------------
# onready.
# -----------------------------------------------
@onready var _ranking_layer = $TextureRect/ScrollContainer/MarginContainer/RankingContainer

# -----------------------------------------------
# function
# -----------------------------------------------


const _ranking_data = [
	{
		'name': 'takewatage',
		'score': '9999',
	},
	{
		'name': 'amagi',
		'score': '0',
	},
	{
		'name': 'watage',
		'score': '0',
	}
]

func _ready() -> void:
	## signal
	## 開いた時
	connect('open_window', _on_open_ranking)
	
	
func _process(_delta: float) -> void:
	#if $NameForm.text.length():
		#print($NameForm.text)
	pass

func _on_open_ranking():

	var service = FirebaseService.new()
	var rankingArray = await service.get_ranking()
	print('--rankingArray--')
	
	
	
	
	
	#for d in _ranking_data:
		#var ranking_content = _ranking_item.instantiate()
		#ranking_content.ranking_name = d.name
		#ranking_content.ranking_score = d.score
		#_ranking_layer.add_child(ranking_content)

func _on_name_form_text_submitted(new_text: String) -> void:
	print(new_text)

func _on_name_form_text_changed(new_text: String) -> void:
	if $NameForm.text.length():
		$NameForm/OkButton.show()
	else:
		$NameForm/OkButton.hide()
