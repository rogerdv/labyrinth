extends Node2D


func _ready() -> void:
	pass # Replace with function body.


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "player":
		# add some time to counter
		GameInstance.time += 15
		queue_free()
