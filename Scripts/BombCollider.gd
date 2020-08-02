extends RayCast2D


var save_margin = 1.0


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta):
	if is_colliding():
		cast_to = Vector2(0,0)
		var collider = get_collider()
		if collider.is_in_group("tilemap"):
			var point = get_collision_point() - get_collision_normal() * save_margin
			var map_point = collider.world_to_map(point)
			var tile_idx = collider.get_cell(map_point.x,map_point.y)
			var tile_name = collider.tile_set.tile_get_name(tile_idx)
			print(tile_name)


