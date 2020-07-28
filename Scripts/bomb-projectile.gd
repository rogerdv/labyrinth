extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export(Vector2) var dir 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide(dir*150,Vector2(0,0),true)
	if  (get_slide_count()>0):
		#coll = get_slide_collision(0)			
		$RayCast2D.cast_to = Vector2(0,30)
