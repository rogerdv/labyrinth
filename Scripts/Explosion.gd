extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name=="Explosion":
		queue_free()