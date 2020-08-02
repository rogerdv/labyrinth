extends Control


var mode:int = 0
var idx:int = 0
var question
var timer:float = 0
var counter:int = 7
var x:int
var y:int
var tmap
var ghost


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


func _process(delta: float) -> void:
	timer += delta
	if timer > 1:
		timer = 0
		counter -= 1
		if counter > 0:
			$PanelContainer/VBoxContainer/HBoxContainer/time.text = String(counter)
		else:
			if mode == 1: 	# failed the question
				# re-enable collision detection
				get_parent().get_node("../player").ToggleCollision(false)
				queue_free()
			else:
				# ghost mode, go back to start
				var start = get_parent().get_node("../SceneInfo").Start
				get_parent().get_node("../player").position = start
				queue_free()


func AnswerPressed(extra_arg_0: int) -> void:
	if question["choices"][extra_arg_0].correct == "yes":
		print("Correct!")

		if mode == 1:
			tmap.set_cell(x, y, 3)
		else:
			ghost.queue_free()
			GameInstance.SceneGhostsKilled += 1

		get_parent().get_node("../SceneInfo").SceneScore +=10

		# update score
		var score = get_parent().get_node("../SceneInfo").SceneScore+GameInstance.score
		get_parent().get_node("InfoBar/Cont/Score").text = String(score)

		#re-enable collision detection
		get_parent().get_node("../player").ToggleCollision(false)
	else:
		get_parent().get_node("../player").ToggleCollision(false)
		
		# ghost mode
		if mode == 2: 	
			var start = get_parent().get_node("../SceneInfo").Start
			get_parent().get_node("../player").position = start

	GameInstance.paused = false
	queue_free()
