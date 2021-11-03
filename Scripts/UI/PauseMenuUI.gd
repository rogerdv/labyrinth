extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):	
	
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			GameInstance.paused=false
			queue_free()
		
func _on_yes_pressed() -> void:
	GameInstance.SaveGame()
	get_tree().change_scene("res://Scenes/main_menu.tscn")


func _on_no_pressed() -> void:
	GameInstance.paused=false
	queue_free()	
