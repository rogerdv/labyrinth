extends KinematicBody2D


onready var joystick = get_parent().get_node("CanvasLayer/UI").get_joystick()


var UP:bool = false
var DOWN:bool = false
var LEFT:bool = false
var RIGHT:bool = false
var LAST_DIR:int = 2
const DIR_UP = 1
const DIR_DN = 2
const DIR_LF = 3
const DIR_RG = 4
const bomb = preload("res://Scenes/bomb_projectile.tscn")
var vec:Vector2
var steps = preload("res://Sounds/stepstone_1.wav")
var map_mode:bool = false
var counter = 0

var dir_vec= Vector2(0,0) 	#direction vector for keyboard based movement

signal animation_finished

func _ready():	
	pass

func get_animator():
	return $AnimationPlayer
	
func _input(event):
	# press events
	
	#release events
	if event is InputEventKey and not event.pressed: 
		if event.scancode==KEY_UP:
			dir_vec.y=0
			UP = false
			if $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.stop()
			
		if event.scancode==KEY_DOWN:
			dir_vec.y=0
			DOWN = false
			if $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.stop()
			
		if event.scancode==KEY_LEFT:
			dir_vec.x=0
			LEFT = false
			if $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.stop()
			
		if event.scancode==KEY_RIGHT:
			dir_vec.x=0
			RIGHT = false
			if $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.stop()
	
	#key pressed events
	if event is InputEventKey and event.pressed: 
		if event.scancode==KEY_SPACE:
			FireBomb()
		
		if event.scancode==KEY_UP:					
			dir_vec.y=-1
			#UP = true			
			LAST_DIR = DIR_UP
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()
			
		if event.scancode==KEY_DOWN:	
			dir_vec.y=1		
			#DOWN = true
			LAST_DIR = DIR_DN
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()
				
		if event.scancode==KEY_LEFT:
			dir_vec.x=-1
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()
			#LEFT = true
			LAST_DIR = DIR_LF
		if event.scancode==KEY_RIGHT:
			dir_vec.x=1
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()
			#RIGHT = true
			LAST_DIR = DIR_RG
		
		if not UP and not DOWN and not LEFT and not RIGHT:
			$AudioStreamPlayer2D.stop()
			$AnimationPlayer.stop()


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
		$AnimationTree.set("parameters/move_vector/blend_position",vec)
		#play the animation according to direction
		if vec.x > 0.1:								
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()
				#$AnimationPlayer.play("walk_right")
				LAST_DIR = DIR_RG
		elif vec.x < -0.1:
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()
				#$AnimationPlayer.play("walk_left")
				LAST_DIR = DIR_LF
		elif vec.y > 0.1:
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()
				#$AnimationPlayer.play("walk_down")
				LAST_DIR = DIR_DN
		elif vec.y < -0.1:
			if not $AudioStreamPlayer2D.playing: 
				$AudioStreamPlayer2D.play()
				#$AnimationPlayer.play("walk_up")
				LAST_DIR = DIR_UP
		elif vec == Vector2(0,0):
			#$AnimationPlayer.stop()
			$AudioStreamPlayer2D.stop()	

			
		if (get_slide_count() > 0):
			coll = get_slide_collision(0)				
			#$AnimationPlayer.stop()
			$AudioStreamPlayer2D.stop()	
			$RayCast2D.cast_to = vec* Vector2(30,30)
			#print("Collided with: ", coll.collider.name)
				

	#if not UP and not DOWN and not LEFT and not RIGHT:
	#	$AudioStreamPlayer2D.stop()
	#	$AnimationPlayer.stop()		
		
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
	
	#if OS.has_touchscreen_ui_hint():
	#	b.dir = vec
	#else:
	vec = Vector2(0,0)
	if LAST_DIR==DIR_UP:
		vec.y = -1
	if LAST_DIR==DIR_DN:
		vec.y = 1
	if LAST_DIR==DIR_LF:
		vec.x = -1
	if LAST_DIR==DIR_RG:
		vec.x = 1
	b.dir = vec

	get_parent().add_child(b)
	b.position = position + vec * 25

func mute_sound():
	$AudioStreamPlayer2D.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	print(anim_name)
	emit_signal("animation_finished",anim_name)
