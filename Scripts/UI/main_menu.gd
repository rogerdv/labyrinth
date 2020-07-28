extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var info = get_node("info")
	#info.text = "Database size "+String(GameInstance.easy.size()) 
	if GameInstance.error!=OK:
		info.text = OS.get_locale()+" Error loadig json "+String(GameInstance.error)
	#else:
	#	info.text = String(GameInstance.error)+": No error, Database size "+String(GameInstance.ghost.size())+" lang "+OS.get_locale() 
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_newgame_pressed():
	get_tree().change_scene("res://Scenes/lab01.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_continue_pressed() -> void:
	GameInstance.LoadGame()
