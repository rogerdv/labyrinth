extends KinematicBody2D


export(Vector2) var dir
var BlastSound = preload("res://Sounds/8bit_bomb_explosion.wav")

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	
	move_and_slide(dir*500,Vector2(0,0),true)
	if  (get_slide_count()>0):
		var collider = get_slide_collision(0)		
		#var coll = get_slide_collision(0)
		#print("Collided with: ", coll.collider.name)
		$RayCast2D.cast_to = Vector2(45,45)*dir
