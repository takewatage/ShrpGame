extends Node

class_name FirebaseService

var COLLECTION_ID = 'ranking'

func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	
func get_ranking():
	var result: Array = []
	if Firebase.Auth.check_auth_file():
		print("Logged in")
		var auth = Firebase.Auth.auth
		print(auth.localid)
		if auth.localid:
			var listTask: FirestoreTask = Firebase.Firestore.list(COLLECTION_ID)
			
			var query: FirestoreQuery = FirestoreQuery.new()
			## FROM a collection
			query.from("ranking")
			## sort
			query.order_by("score", FirestoreQuery.DIRECTION.DESCENDING)
			## LIMIT to the first 10
			query.limit(3)
			
			#var task: FirestoreTask = Firebase.Firestore.query(query)
			var task = Firebase.Firestore.query(query)
			
			var res = await task.task_finished

		
			print("OK")
			print(res.data)


func login_anonymous():
	Firebase.Auth.login_anonymous()

func on_login_succeeded(auth):
	print(auth)
	print('Login success!')
	Firebase.Auth.save_auth(auth)
	
func on_signup_succeeded(auth):
	print(auth)
	print('Sign up success!"')
	Firebase.Auth.save_auth(auth)
	
func on_login_failed(error_code, message):
	print(error_code)
	print("Login failed. Error: %s" % message)
	
func on_signup_failed(error_code, message):
	print(error_code)
	print("Sign up failed. Error: %s" % message)
	
func on_result_query_fin(res: Array):
	print(res)
