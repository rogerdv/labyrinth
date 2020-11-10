extends RayCast2D


var save_margin = 1.0
var blast = preload("res://Scenes/Explosion.tscn")

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta):
	if is_colliding():
		var BlastEffect = blast.instance()
		print("bomb is colliding")
		cast_to = Vector2(0,0)
		var collider = get_collider()
		#print("Collided with: ", collider.name)
		if collider.is_in_group("tilemap"):
			var point = get_collision_point() - get_collision_normal() * save_margin
			var map_point = collider.world_to_map(point)
			var pos =collider.map_to_world(Vector2(map_point.x, map_point.y))
			
			BlastEffect.position = pos+Vector2(32,32)
			get_parent().get_parent().add_child(BlastEffect)
			collider.set_cell(map_point.x, map_point.y, 3)			
			#time penalty
			GameInstance.time-=5
		else:
			BlastEffect.position = collider.position
			get_parent().get_parent().add_child(BlastEffect)
			collider.queue_free()
		
		get_parent().queue_free()


