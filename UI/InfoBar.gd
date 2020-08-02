extends Control


func _ready() -> void:
	pass # Replace with function body.


func _on_Map_pressed() -> void:
	get_node("../../player").ToggleCamera(false)
	get_node("../../Camera2D").current = true


func _on_Fire_pressed() -> void:
	get_node("../../player").FireBomb()
