extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	if Firebase.Auth.check_auth_file():
		%StateLabel.text = "Logged in"
		var auth = Firebase.Auth.auth
		print(auth.localid)
		if auth.localid:
			var collection: FirestoreCollection = Firebase.Firestore.collection('ranking')
			var data = {
				'name': 'takewatage',
				'score': 9999,
			}
			
			var now = Time.get_datetime_dict_from_system()
			print(now)
			var now_format = "%04d-%02d-%02d %02d:%02d:%02d"%[now["year"], now["month"], now['day'], now['hour'], now['minute'], now['second']] 
			
			var task: FirestoreTask = collection.update(now_format + auth.localid, data) 
		
		print("OK")
		#get_tree().change_scene_to_file("res://Game.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_login_button_pressed():
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Firebase.Auth.login_with_email_and_password(email, password)
	%StateLabel.text = "Logging in"

func _on_signup_button_pressed():
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Firebase.Auth.signup_with_email_and_password(email, password)
	%StateLabel.text = "Singing up"

func on_login_succeeded(auth):
	print(auth)
	%StateLabel.text = "Login success!"
	Firebase.Auth.save_auth(auth)
	#get_tree().change_scene_to_file("res://Game.tscn")
	
func on_signup_succeeded(auth):
	print(auth)
	%StateLabel.text = "Sign up success!"
	Firebase.Auth.save_auth(auth)
	#get_tree().change_scene_to_file("res://Game.tscn")
	
func on_login_failed(error_code, message):
	print(error_code)
	print(message)
	%StateLabel.text = "Login failed. Error: %s" % message
	
func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
	%StateLabel.text = "Sign up failed. Error: %s" % message


func _on_logout_button_pressed() -> void:
	Firebase.Auth.logout()
	%StateLabel.text = "Log out!!!"

## 匿名
func _on_signup_button_2_pressed() -> void:
	Firebase.Auth.login_anonymous()
	%StateLabel.text = "Singing2 up"
