extends HBoxContainer

# -----------------------------------------------
#signal.
# -----------------------------------------------


# -----------------------------------------------
# const.
# -----------------------------------------------


# -----------------------------------------------
# export.
# -----------------------------------------------
@export var ranking_name :String = ''
@export var ranking_score :String = '0'

# -----------------------------------------------
# variable
# -----------------------------------------------


# -----------------------------------------------
# onready.
# -----------------------------------------------


# -----------------------------------------------
# function
# -----------------------------------------------
func _ready() -> void:
	$Name.text = ranking_name
	$Score.text = ranking_score
