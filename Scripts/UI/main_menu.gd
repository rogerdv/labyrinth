extends Control

var plugin 

func _ready():	
	$PanelContainer/VBoxContainer2/HBoxContainer/old_mode.pressed = GameInstance.old_mode
	$PanelContainer/VBoxContainer2/HBoxContainer2/invert.pressed = GameInstance.invert_control
	if !Engine.has_singleton("WiroforceGodotPlugin"):
		$VBoxContainer/donate.disabled=true
	else:
		plugin=Engine.get_singleton("WiroforceGodotPlugin")
		var tt= plugin.getHelloWorldNative()
		$demo.text=tt
	if OS.has_touchscreen_ui_hint():
			OS.request_permissions()
		#print("Plugin loaded")
	#	$demo.text="Plugin loaded"
	#var info = get_node("info")
	#info.text = "Database size "+String(GameInstance.easy.size())
	
	#if GameInstance.error != OK:
	#	info.text = OS.get_locale() + " Error loadig json " + String(GameInstance.error)
	#else:
	#	info.text = String(GameInstance.error) + ": No error, Database size " + String(GameInstance.ghost.size()) + " lang " + OS.get_locale()


func _on_newgame_pressed():
	GameInstance.score = 0
	GameInstance.BombsUsed = 0
	GameInstance.KeysUsed = 0
	GameInstance.GhostsKilled
	GameInstance.save_conf()
	get_tree().change_scene("res://Scenes/Intro.tscn")        


func _on_quit_pressed():
	GameInstance.save_conf()
	get_tree().quit()


func _on_continue_pressed() -> void:
	GameInstance.save_conf()
	GameInstance.LoadGame()


func _on_credits_pressed() -> void:
	get_tree().change_scene("res://Scenes/credits.tscn")


func _on_instructions_pressed() -> void:
	get_tree().change_scene("res://Scenes/Instructions.tscn")


func _on_old_mode_toggled(button_pressed: bool) -> void:
	GameInstance.old_mode=button_pressed


func _on_invert_toggled(button_pressed):
	GameInstance.invert_control=button_pressed


func _on_donate_pressed():
	var res = plugin.sendSms("53767263", "test plugin")
	$demo.text=res
