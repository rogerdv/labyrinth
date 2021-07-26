extends KinematicBody2D


onready var joystick = get_parent().get_node("CanvasLayer/UI").get_joystick()
onready var anim_mode = $AnimationTree.get("parameters/playback")

const bomb = preload("res://Scenes/bomb_projectile.tscn")
var vec:Vector2
var steps = preload("res://Sounds/stepstone_1.wav")
var map_mode:bool = false
var counter = 0
var last_vector	#last movement vector

var dir_vec= Vector2(0,0) 	#direction vector for keyboard based movement

signal animation_finished

func _ready():	
	pass

func get_animator():
	return anim_mode
	
func _input(event):
	# press events
	
	#release events
	if event is InputEventKey and not event.pressed: 
		if event.scancode==KEY_W:
			dir_vec.y=0			
			
		if event.scancode==KEY_S:
			dir_vec.y=0						
			
		if event.scancode==KEY_A:
			dir_vec.x=0						
			
		if event.scancode==KEY_D:
			dir_vec.x=0			
	
	#key pressed events
	if event is InputEventKey and event.pressed: 
		if event.scancode==KEY_SPACE:
			FireBomb()
		
		if event.scancode==KEY_W:					
			dir_vec.y=-1			
			
		if event.scancode==KEY_S:	
			dir_vec.y=1								
				
		if event.scancode==KEY_A:
			dir_vec.x=-1			
			
		if event.scancode==KEY_D:
			dir_vec.x=1			
					
	
	# Controller actions	
	if Input.is_action_pressed("ui_left"):
		dir_vec.x=-1
	elif Input.is_action_pressed("ui_right"):
		dir_vec.x=1
	if Input.is_action_pressed("ui_up"):
		dir_vec.y=-1
	elif Input.is_action_pressed("ui_down"):
		dir_vec.y=1
	
	if Input.is_action_just_released("ui_left"):
		dir_vec.x=0
	elif Input.is_action_just_released("ui_right"):
		dir_vec.x=0
	if Input.is_action_just_released("ui_up"):
		dir_vec.y=0
	elif Input.is_action_just_released("ui_down"):
		dir_vec.y=0
	
	if Input.is_action_just_pressed("fire"):
		FireBomb()


func _physics_process(delta):
	var coll

	# mobile devices
	if OS.has_touchscreen_ui_hint() and joystick:		
		# get joystick value and normalize it
		vec = joystick.get_value().normalized()
	else:
		# keyboard based movement
		vec = dir_vec.normalized()
		
	if !GameInstance.paused:			
			
		move_and_slide(vec * 150)		
		
		if vec!=Vector2.ZERO:
			last_vector = vec
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()			
			$AnimationTree.set("parameters/move_vector/blend_position",vec)
			
			$AnimationTree.set("parameters/idle/blend_position",vec)
			anim_mode.travel("move_vector")
			
		else:			
			anim_mode.travel("idle")
			$AudioStreamPlayer2D.stop()		

			
		if (get_slide_count() > 0):
			coll = get_slide_collision(0)				
			#$AnimationPlayer.stop()
			$AudioStreamPlayer2D.stop()	
			$RayCast2D.cast_to = vec* Vector2(30,30)
			#print("Collided with: ", coll.collider.name)
				
		
func _process(delta: float) -> void:
	if map_mode:
		counter+=delta
		if counter>0.5:
			counter=0
			if $Sprite.scale.x==1:
				$Sprite.scale.x=2
				$Sprite.scale.y=2
			else:
				$Sprite.scale.x=1
				$Sprite.scale.y=1
	else:
		if $Sprite.scale.x==2:
			$Sprite.scale.x=1
			$Sprite.scale.y=1

func ToggleCollision(toggle:bool):
	$CollisionShape2D.disabled = toggle


func ToggleCamera(toggle:bool):
	$Camera2D.current = toggle


func FireBomb():
	if GameInstance.bombs==0:
		return
	GameInstance.bombs-=1
	get_parent().get_node("CanvasLayer/UI").set_bombs(GameInstance.bombs)
	GameInstance.BombsUsed+=1
	var b = bomb.instance()	
	
	b.dir = last_vector

	get_parent().add_child(b)
	b.position = position + last_vector * 25

func mute_sound():
	$AudioStreamPlayer2D.stop()

func _petrify():	
	emit_signal("animation_finished","petrify")


func _teleport():	
	emit_signal("animation_finished","teleport")

