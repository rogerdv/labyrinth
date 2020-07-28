extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export(int) var chance = 5
var PlayerVisible:bool = false
var path
onready var nav = get_node("../Navigation2D")
const CHARACTER_SPEED = 110

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	$Sprite.visible = false
	$AnimationPlayer.play("idle")

func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class
	# it returns a PoolVector2Array of points that lead you from the
	# start_position to the end_position
	path = nav.get_simple_path(start_position, end_position, true)
	# The first point is always the start_position
	# We don't need it in this example as it corresponds to the character's position
	path.remove(0)
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerVisible and !GameInstance.paused:
		var r = randi()%1000
		if r<chance:
			$Sprite.visible = true

	if $Sprite.visible and !GameInstance.paused:		#We are working
		#print("The sprite is visible, check path")
		path = nav.get_simple_path(global_position, get_node("../player").global_position)
		if path.size()>0:
			#there is a path to player		
			#print("There is path")	
			var walk_distance = CHARACTER_SPEED * delta
			move_along_path(walk_distance)
			
		
		#var space_state = get_world_2d().direct_space_state
		#var result = space_state.intersect_ray(global_position, get_node("../player").global_position, [self])

func move_along_path(distance):
	var last_point = global_position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		
		# the position to move to falls between two points
		if distance <= distance_between_points:
			global_position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		
		# the position is past the end of the segment
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# the character reached the end of the path
	global_position = last_point
	set_process(false)
	
func _on_VisibilityNotifier2D_screen_entered() -> void:
	print("Entered visible area!!")
	PlayerVisible = true
	randomize()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	print("Not visible, disabling")
	$Sprite.visible = false


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name=="player":
		var panel = preload("res://UI/QuestionPanel.tscn").instance()
		panel.mode = 2		
		panel.ghost = self
		get_node("../CanvasLayer").add_child(panel)						
