extends Control


func _ready() -> void:
	pass # Replace with function body.

func update_time(percent):
	$Cont/MarginContainer/progress.value = percent

func set_score(score):
	$Cont/Score.text = String(score)

func set_keys(keys):
	$Cont/keys.text = String(keys)
	
func set_bombs(bombs):
	$Cont/bombs.text = String(bombs)
	
func _on_Map_pressed() -> void:
	get_node("../../player").ToggleCamera(false)
	get_node("../../Camera2D").current = true


func _on_Fire_pressed() -> void:
	get_node("../../player").FireBomb()
	
func get_joystick():
	return $Sprite/TouchScreenButton
