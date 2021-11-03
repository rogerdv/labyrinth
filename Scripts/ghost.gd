extends KinematicBody2D


export(int) var chance = 20
var PlayerVisible:bool = false
var path
onready var nav = get_node("../Navigation2D")
const CHARACTER_SPEED = 110
var DelayCounter = 0
onready var anim_mode = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	$Sprite.visible = false
	$Area2D.monitoring = false
	#$AnimationPlayer.play("idle")


func _process(delta: float) -> void:
	var player_pos = get_node("../player").position	
	
	if !$Sprite.visible and PlayerVisible and !GameInstance.paused and position.distance_to(player_pos)<350:
		var r = randi()%1000
		if r < chance:
			$Sprite.visible = true
			$Area2D.monitoring = true
			$AudioStreamPlayer2D.play()
			anim_mode.start("spawn")
			#$AnimationPlayer.play("spawn")

	if $Sprite.visible and !GameInstance.paused:		#We are working
		if DelayCounter<1:
			DelayCounter+=delta
			return
			
		#print("The sprite is visible, check path")
		path = nav.get_simple_path(global_position, get_node("../player").global_position)
		if path.size()>0:
			#there is a path to player
			#print("There is path")
			var walk_distance = CHARACTER_SPEED * delta
			#print(global_position)
			#print(path[0])
			#var d = global_position.direction_to(path[0])
			#print(d)
			move_along_path(walk_distance)

		#var space_state = get_world_2d().direct_space_state
		#var result = space_state.intersect_ray(global_position, get_node("../player").global_position, [self])

func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class
	# it returns a PoolVector2Array of points that lead you from the
	# start_position to the end_position
	path = nav.get_simple_path(start_position, end_position, true)
	# The first point is always the start_position
	# We don't need it in this example as it corresponds to the character's position
	path.remove(0)
	set_process(true)


func move_along_path(distance):
	var last_point = global_position
	
	
	
		
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])	
		var d = last_point.direction_to(path[0])	
		#print(d)
		$AnimationTree.set("parameters/move/blend_position", d.normalized())
		anim_mode.travel("move")			

		# the position to move to falls between two points
		if distance <= distance_between_points and distance_between_points>0:
			global_position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return

		# the position is past the end of the segment
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# the character reached the end of the path
	global_position = last_point
	set_process(false)
	anim_mode.start("idle")
	#$AnimationPlayer.play("idle")

func _on_VisibilityNotifier2D_screen_entered() -> void:	
	PlayerVisible = true
	randomize()


func _on_VisibilityNotifier2D_screen_exited() -> void:	
	PlayerVisible = false
	$Sprite.visible = false
	$Area2D.monitoring = false
	$AudioStreamPlayer2D.stop()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name=="player" and $Sprite.visible:
		var panel = preload("res://UI/QuestionPanel.tscn").instance()
		#panel.connect("correct",get_node("../SceneInfo"),"correct")
		#panel.connect("wrong",get_node("../SceneInfo"),"wrong")
		panel.mode = 2
		panel.ghost = self
		get_node("../CanvasLayer").add_child(panel)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name!="idle":
		$AnimationPlayer.play("idle")
