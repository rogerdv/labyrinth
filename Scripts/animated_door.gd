extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var tile_map
var tile_index	#tile to set after animation ends
var x
var y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	GameInstance.paused = false
	#tile_map.set_cell(x, y, tile_index)
	queue_free()
