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
const bomb = "res://Scenes/bomb-projectile.tscn"
var vec:Vector2


func _ready():
	pass # Replace with function body.


func _input(event):
	# press events
	
	#release events
	if Input.is_action_just_released("ui_up"):
		UP = false
	if Input.is_action_just_released("ui_down"):
		DOWN = false
	if Input.is_action_just_released("ui_left"):
		LEFT = false
	if Input.is_action_just_released("ui_right"):
		RIGHT = false
	if event is InputEventKey and event.pressed: 
		if event.scancode==KEY_SPACE:
			FireBomb()
		if event.scancode==KEY_UP:
			UP = true
			LAST_DIR = DIR_UP
		if event.scancode==KEY_DOWN:
			DOWN = true
			LAST_DIR = DIR_DN
		if event.scancode==KEY_LEFT:
			LEFT = true
			LAST_DIR = DIR_LF
		if event.scancode==KEY_RIGHT:
			RIGHT = true
			LAST_DIR = DIR_RG


func _physics_process(delta):
	var coll

	# mobile devices
	if OS.has_touchscreen_ui_hint() and joystick:
		if !GameInstance.paused:
			# get joystick value and normalize it
			vec = joystick.get_value().normalized()
			move_and_slide(vec * 150)

			#play the animation according to direction
			if vec.x > 0.1:
				$AnimationPlayer.play("walk_right")
				LAST_DIR = DIR_RG
			elif vec.x < -0.1:
				$AnimationPlayer.play("walk_left")
				LAST_DIR = DIR_LF
			elif vec.y > 0.1:
				$AnimationPlayer.play("walk_down")
				LAST_DIR = DIR_DN
			elif vec.y < -0.1:
				$AnimationPlayer.play("walk_up")
				LAST_DIR = DIR_UP
			elif vec == Vector2(0,0):
				$AnimationPlayer.stop()
			if (get_slide_count() > 0):
				coll = get_slide_collision(0)
			#print("Collided with: ", coll.collider.name)
			#print(vec.normalized())
				$RayCast2D.cast_to = vec* Vector2(30,30)

	if !GameInstance.paused:
		# keyboard based movement
		if UP:
			#translate(Vector2(0,-150*delta))
			move_and_slide(Vector2(0,-150), Vector2(0,0), true)
			$AnimationPlayer.play("walk_up")

			if (get_slide_count() > 0):
				coll = get_slide_collision(0)
				print("Collided with: ", coll.collider.name)
				$RayCast2D.cast_to = Vector2(0,-30)

		if DOWN:
			move_and_slide(Vector2(0,150), Vector2(0,0), true)
			$AnimationPlayer.play("walk_down")
			if  (get_slide_count()>0):
				#coll = get_slide_collision(0)
				$RayCast2D.cast_to = Vector2(0,30)

		if LEFT:
			move_and_slide(Vector2(-150,0), Vector2(0,0), true)
			$AnimationPlayer.play("walk_left")

			if get_slide_count() > 0:
				$RayCast2D.cast_to= Vector2(-25,0)

		if RIGHT:
			move_and_slide(Vector2(150,0), Vector2(0,0), true)
			$AnimationPlayer.play("walk_right")

			if get_slide_count() > 0:
				$RayCast2D.cast_to = Vector2(25,0)


func ToggleCollision(toggle:bool):
	$CollisionShape2D.disabled = toggle


func ToggleCamera(toggle:bool):
	$Camera2D.current = toggle


func FireBomb():
	var b = load(bomb).instance()
	
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
	b.position = position + vec * 20
