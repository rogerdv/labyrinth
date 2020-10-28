extends KinematicBody2D


export(Vector2) var dir


func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	print(dir)
	move_and_slide(dir,Vector2(0,0),true)
	if  (get_slide_count()>0):
		#coll = get_slide_collision(0)
		$RayCast2D.cast_to = Vector2(0,30)
