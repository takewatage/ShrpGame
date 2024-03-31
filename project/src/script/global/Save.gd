extends Node

## セーブデータのファイルパス.
const PATH_SAVEDATA = "user://savedata.txt"

# セーブデータを辞書型で定義.
var savedata = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _save(data_to_save: Dictionary) -> void:
	print("セーブ...")
	
	var _savedata = {
		'hi_score': 0,
		'setting_volume': 0
	}
	
	# 引数のデータを_savedataにマージ
	for key in data_to_save.keys():
		_savedata[key] = data_to_save[key]
	
	# ファイルを書き込みモードで開く.
	var f = FileAccess.open(PATH_SAVEDATA, FileAccess.WRITE)
	
	# セーブデータを文字列に変換.
	var s = var_to_str(_savedata)
	f.store_string(s)
	savedata = _savedata
	
	# ファイルを閉じる.
	f.close()
	
	
func _load() -> void:
	if FileAccess.file_exists(PATH_SAVEDATA) == false:
		print("セーブデータが存在しません: %s"%PATH_SAVEDATA)
		_save({})
		return
	
	var f = FileAccess.open(PATH_SAVEDATA, FileAccess.READ)
	var s = f.get_as_text()
	# 文字列をセーブデータに変換.
	savedata = str_to_var(s)
	print(savedata)
	
	# ファイルを閉じる.
	f.close()
	
	
func getSaveData(_key):
	if _key in savedata:
		return savedata[_key]
	
