extends RayCast2D


var save_margin = 1.0


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta):
	if is_colliding():
		print("bomb is colliding")
		cast_to = Vector2(0,0)
		var collider = get_collider()
		#print("Collided with: ", collider.name)
		if collider.is_in_group("tilemap"):
			var point = get_collision_point() - get_collision_normal() * save_margin
			var map_point = collider.world_to_map(point)
			collider.set_cell(map_point.x, map_point.y, 3)
			#time penalty
			GameInstance.time-=5
		else:
			collider.queue_free()
		
		get_parent().queue_free()


