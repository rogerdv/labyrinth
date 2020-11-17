extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/ScoreContainer/score.text = String(GameInstance.score)
	$VBoxContainer/KeysContainer/KeysUsed.text = String(GameInstance.KeysUsed)
	$VBoxContainer/GhostkContainer/Gkilled.text = String(GameInstance.GhostsKilled)


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_BacktoMain_pressed() -> void:
	get_tree().change_scene("res://Scenes/main_menu.tscn")
