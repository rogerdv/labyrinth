extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Map_pressed() -> void:
	
	get_node("../../player").ToggleCamera(false)
	get_node("../../Camera2D").current = true


func _on_Fire_pressed() -> void:
	get_node("../../player").FireBomb()
