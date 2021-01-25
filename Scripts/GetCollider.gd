extends RayCast2D


# gets the tile we are colliding
var save_margin = 1.0
var exit_anim = preload("res://Scenes/animated_exit.tscn")

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
			get_node("../AudioStreamPlayer2D").stop()
			match tile_name:
				"door":					
					 # disable collider
					get_parent().ToggleCollision(true)
					# pause and display question
					var panel = preload("res://UI/QuestionPanel.tscn").instance()
					panel.connect("correct",get_parent().get_node("../SceneInfo"),"correct")
					panel.connect("wrong",get_parent().get_node("../SceneInfo"),"wrong")
					panel.mode = 1
					panel.x = map_point.x
					panel.y = map_point.y
					panel.tmap = collider
					get_parent().get_node("../CanvasLayer").add_child(panel)
				"exit":
					var exit_door = exit_anim.instance()
					exit_door.connect("finished", self, "_exit_anim_end")
					get_parent().get_parent().add_child(exit_door)
					exit_door.position =collider.map_to_world(Vector2(map_point.x, map_point.y))
					#GameInstance.NextScene = get_parent().get_node("../SceneInfo").NextLevel
					#update score
					#GameInstance.score += get_parent().get_node("../SceneInfo").SceneScore					
					#get_tree().change_scene("res://Scenes/transition.tscn")

func _exit_anim_end():
	GameInstance.NextScene = get_parent().get_node("../SceneInfo").NextLevel
	#update score
	GameInstance.score += get_parent().get_node("../SceneInfo").SceneScore
	#print("Next scene is "+scene)
	get_tree().change_scene("res://Scenes/transition.tscn")
	
