extends Control


var mode:int = 0
var idx:int = 0
var question
var timer:float = 0
var counter:int = 8
var x:int
var y:int
var tmap
var ghost
var fail_sound = preload("res://Sounds/sfx_sounds_error8.wav")
var correct_sound = preload("res://Sounds/sfx_sounds_fanfare3.wav")
var door_anim = preload("res://Scenes/animated_door.tscn")


func _ready() -> void:			
	$PanelContainer/VBoxContainer/HBoxContainer/time.text = String(counter)	
	
	if (mode == 1):
		# get a random question
		question = GameInstance.get_easy_rand_question()
	elif (mode == 2):
		# get a random question
		question = GameInstance.get_ghost_rand_question()

	# populate question, topic and choices
	$PanelContainer/VBoxContainer/question.text = question["question"]
	$PanelContainer/VBoxContainer/topic.text = question["topic"]
	$PanelContainer/VBoxContainer/a1.text = question['choices'][0]["answer"]
	$PanelContainer/VBoxContainer/a2.text = question['choices'][1]["answer"]
	$PanelContainer/VBoxContainer/a3.text = question['choices'][2]["answer"]
	$PanelContainer/VBoxContainer/a4.text = question['choices'][3]["answer"]

	GameInstance.paused = true
	get_parent().get_node("../player").mute_sound()


func _process(delta: float) -> void:
	timer += delta
	if timer > 1:
		timer = 0
		counter -= 1
		if counter > 0:
			$PanelContainer/VBoxContainer/HBoxContainer/time.text = String(counter)
		else:
			# failed the question, time out
			$AudioStreamPlayer.stream = fail_sound
			if not $AudioStreamPlayer.playing:				
				$AudioStreamPlayer.play()
			if mode == 1:				
				tmap.set_cell(x, y, 0)	
				# re-enable collision detection
				get_parent().get_node("../player").ToggleCollision(false)
				GameInstance.paused = false
				#queue_free()
			else:
				# ghost mode, go back to start				
				var start = get_parent().get_node("../SceneInfo").Start
				get_parent().get_node("../player").position = start
				get_parent().get_node("../player").ToggleCollision(false)
				get_parent().get_node("../player").get_animator().play("teleport")
				GameInstance.paused = false
				#queue_free()


func AnswerPressed(extra_arg_0: int) -> void:	
	if question["choices"][extra_arg_0].correct == "yes":	
		#correct
		$AudioStreamPlayer.stream = correct_sound
		if not $AudioStreamPlayer.playing:			
			$AudioStreamPlayer.play()
		if mode == 1:
			#replace tile by animated door
			tmap.set_cell(x, y, 3)
			var d_anim = door_anim.instance()
			#d_anim.tile_map = tmap
			#d_anim.tile_index = 3
			#d_anim.x =x 
			#d_anim.y = y
			var pos =tmap.map_to_world(Vector2(x, y))
			d_anim.position = pos+Vector2(32,32)
			get_parent().get_parent().add_child(d_anim)
			get_parent().get_node("../SceneInfo").SceneScore +=10

			# update score
			var score = get_parent().get_node("../SceneInfo").SceneScore+GameInstance.score
			get_parent().get_node("../CanvasLayer/UI").set_score(score)

			#re-enable collision detection
			get_parent().get_node("../player").ToggleCollision(false)			
			#queue_free()
			return
			
		else:
			ghost.queue_free()
			GameInstance.SceneGhostsKilled += 1

		get_parent().get_node("../SceneInfo").SceneScore +=10

		# update score
		var score = get_parent().get_node("../SceneInfo").SceneScore+GameInstance.score
		get_parent().get_node("../CanvasLayer/UI").set_score(score)

		#re-enable collision detection
		get_parent().get_node("../player").ToggleCollision(false)
		emit_signal("correct")
	else:	#failed 
		$AudioStreamPlayer.stream = fail_sound
		if not $AudioStreamPlayer.playing:			
			$AudioStreamPlayer.play()
		
		
		get_parent().get_node("../player").ToggleCollision(false)
		if mode == 1:
			tmap.set_cell(x, y, 0)		
		else: 	# ghost mode			
			var start = get_parent().get_node("../SceneInfo").Start
			get_parent().get_node("../player").position = start			
			ghost.queue_free()

	GameInstance.paused = false
	#queue_free()


func _on_UseKey_pressed() -> void:
	if GameInstance.keys>0:
		GameInstance.keys-=1
		GameInstance.KeysUsed+=1
		get_parent().get_node("../CanvasLayer/UI").set_keys(GameInstance.keys)
	if mode == 1:
			tmap.set_cell(x, y, 3)
	else:
		ghost.queue_free()	
	get_parent().get_node("../player").ToggleCollision(false)
	GameInstance.paused = false
	queue_free()


func _on_AudioStreamPlayer_finished():
	if mode!=1:
		get_parent().get_node("../player").get_animator().play("teleport")
	queue_free()
