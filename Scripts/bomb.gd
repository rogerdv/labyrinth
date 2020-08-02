extends Node2D


func _ready() -> void:
	pass # Replace with function body.


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "player":
		GameInstance.bombs += 1
		get_parent().get_node("CanvasLayer/InfoBar/Cont/bombs").text = String(GameInstance.bombs)
		queue_free()
