extends Node

class_name ArrayUtility

## 最小の値を取得
static func get_array_min(arr: Array, key: String) -> Dictionary:
    return arr.reduce(func(_min, _val): return _val if _is_length_greater(_val, _min, key) else _min)
    
static func _is_length_greater(a, b, key) -> bool:
    return a[key] < b[key]
