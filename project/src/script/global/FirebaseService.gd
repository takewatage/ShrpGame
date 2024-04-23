extends Node

signal login_success(bool)

## top10まで表示
const RANKING_COUNT = 10

var COLLECTION_ID = 'ranking'

## ランキング格納
var ranking_data = []

func _ready() -> void:
    #Firebase.Auth.login_succeeded.connect(_on_login_succeeded)
    #Firebase.Auth.signup_succeeded.connect(_on_signup_succeeded)
    #Firebase.Auth.login_failed.connect(_on_login_failed)
    #Firebase.Auth.signup_failed.connect(_on_signup_failed)
    Firebase.Firestore.collection(COLLECTION_ID).get_document.connect(_on_document_get)
    
    
func is_auth() -> bool:
    return Firebase.Auth.check_auth_file()
        
func login():
    if Firebase.Auth.check_auth_file():
        return self
    else:
        Firebase.Auth.login_anonymous()
        return self
    
## ランキング取得
func get_ranking() -> Array:
    ranking_data = []
    if Firebase.Auth.check_auth_file():
        var auth = Firebase.Auth.auth
        if auth.localid:
            # ranking コレクション取得
            var list_task: FirestoreTask = Firebase.Firestore.list(COLLECTION_ID)
            var res = await list_task.task_finished
            for i in res.data:
                ranking_data.append(i.doc_fields)
    
    # score 降順
    ranking_data.sort_custom(func(a, b): return a.score > b.score)
    
    return ranking_data
    
## ランキング更新
func add_ranking(ranking_model: Ranking) -> void:
    if Firebase.Auth.check_auth_file():
        var auth = Firebase.Auth.auth
        if auth.localid:
            var document = ranking_model.game_id
            var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
            var task: FirestoreTask = collection.add(document, ranking_model.get_postable())
            await task.task_finished
            
## RANKING_COUNT以上ランキングがあったら一番低いデータを削除
func remove_ranking() -> void:
    var _arr = ranking_data
    var min_data = ArrayUtility.get_array_min(_arr, 'score')
    if Firebase.Auth.check_auth_file():
        var auth = Firebase.Auth.auth
        if auth.localid:
            var document = min_data.game_id
            var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
            var task: FirestoreTask = collection.delete(document)
            await task.task_finished
    

func _on_login_succeeded(auth) -> void:
    Firebase.Auth.save_auth(auth)
    login_success.emit(true)
    
func _on_signup_succeeded(auth) -> void:
    Firebase.Auth.save_auth(auth)
    login_success.emit(true)
    
func _on_login_failed(error_code, message) -> void:
    print(error_code)
    print("Login failed. Error: %s" % message)
    Firebase.Auth.logout()
    login_success.emit(false)
    
func _on_signup_failed(error_code, message) -> void:
    print(error_code)
    print("Sign up failed. Error: %s" % message)
    login_success.emit(false)
    
func _on_document_get():
    print("doc get complete")
    
#func _on_delete_document(_val):
    #print("delete doc complete!!!")
    #print(_val)
