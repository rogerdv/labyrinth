extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var mode:int = 0
var idx:int=0
var q
var timer:float=0
var counter:int = 7
var x:int 
var y:int
var tmap
var ghost


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/VBoxContainer/HBoxContainer/time.text = String(counter)
	if (mode==1):		
		idx = randi()%GameInstance.easy.size()
		#check if question was recently displayed
		while GameInstance.PrevEasy.has(idx):
			idx = randi()%GameInstance.easy.size()
		if GameInstance.PrevEasy.size()==5:
			GameInstance.PrevEasy.remove(0)
			GameInstance.PrevEasy.append(idx)
		else:
			GameInstance.PrevEasy.append(idx)
		q = GameInstance.easy[idx]
		$PanelContainer/VBoxContainer/question.text = q["question"]
		$PanelContainer/VBoxContainer/topic.text = q["topic"]
		var answers = q["choices"]
		answers.shuffle()		
		$PanelContainer/VBoxContainer/a1.text = answers[0]["answer"]
		$PanelContainer/VBoxContainer/a2.text = answers[1]["answer"]
		$PanelContainer/VBoxContainer/a3.text = answers[2]["answer"]
		$PanelContainer/VBoxContainer/a4.text = answers[3]["answer"]
	elif (mode==2):
		idx = randi()%GameInstance.ghost.size()	
		while GameInstance.PrevGhost.has(idx):
			idx = randi()%GameInstance.ghost.size()
		if GameInstance.PrevGhost.size()==5:
			GameInstance.PrevGhost.remove(0)
			GameInstance.PrevGhost.append(idx)
		else:
			GameInstance.PrevGhost.append(idx)
		q = GameInstance.ghost[idx]
		$PanelContainer/VBoxContainer/question.text = q["question"]
		$PanelContainer/VBoxContainer/topic.text = q["topic"]
		var answers = q["choices"]
		answers.shuffle()		
		$PanelContainer/VBoxContainer/a1.text = answers[0]["answer"]
		$PanelContainer/VBoxContainer/a2.text = answers[1]["answer"]
		$PanelContainer/VBoxContainer/a3.text = answers[2]["answer"]
		$PanelContainer/VBoxContainer/a4.text = answers[3]["answer"]
	
	GameInstance.paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer+=delta
	if timer>1:
		timer=0
		counter-=1
		if counter>0:
			$PanelContainer/VBoxContainer/HBoxContainer/time.text = String(counter)
		else:
			if mode==1: 	#failed the question
				#re-enable collision detection
				get_parent().get_node("../player").ToggleCollision(false) 
				queue_free()		
			else:
				#ghost mde, go back to start
				var start = get_parent().get_node("../SceneInfo").Start
				get_parent().get_node("../player").position = start
				queue_free()


func AnswerPressed(extra_arg_0: int) -> void:		
	if q["choices"][extra_arg_0].correct=="yes":
		print("Correct!")	
		if mode==1:	
			tmap.set_cell(x,y,3)
		else:
			ghost.queue_free()
			GameInstance.SceneGhostsKilled+=1
		get_parent().get_node("../SceneInfo").SceneScore +=10
		#update score
		var score = get_parent().get_node("../SceneInfo").SceneScore+GameInstance.score
		get_parent().get_node("InfoBar/Cont/Score").text = String(score)
		#re-enable collision detection
		get_parent().get_node("../player").ToggleCollision(false) 
	else:
		get_parent().get_node("../player").ToggleCollision(false) 
		if mode==2: 	#ghost mode
			var start = get_parent().get_node("../SceneInfo").Start
			get_parent().get_node("../player").position = start
	GameInstance.paused = false
	queue_free()
