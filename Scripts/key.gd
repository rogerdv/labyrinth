extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name=="player":
		GameInstance.keys+=1
		get_parent().get_node("CanvasLayer/InfoBar/Cont/keys").text = String(GameInstance.keys)
		queue_free()
	
