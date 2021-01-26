extends Node


export(String) var NextLevel
var SceneScore: int =0
var Start:Vector2
var timer:float = 0
var mapviews:int = 0
var mapmode:bool = false
var MapTimeCounter
var PauseMenuScene = preload("res://UI/PauseMenu.tscn")
var fail_sound = preload("res://Sounds/sfx_sounds_error8.wav")
var correct_sound = preload("res://Sounds/sfx_sounds_fanfare3.wav")

func _ready() -> void:
	Start = get_node("../player").position
	GameInstance.time = GameInstance.MAXTIME
	GameInstance.SceneScore = 0
	GameInstance.SceneBombsUsed = 0
	GameInstance.SceneKeysUsed = 0
	GameInstance.SceneGhostsKilled = 0	


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_M:
			display_map()			
		elif event.scancode == KEY_F5:
			GameInstance.SaveGame()
		elif 	event.scancode == KEY_F6:
			GameInstance.LoadGame()
		elif event.scancode == KEY_ESCAPE:
			GameInstance.paused = true			
			get_node("../CanvasLayer").add_child(PauseMenuScene.instance())		


func _process(delta: float) -> void:
	if mapmode:
		MapTimeCounter+=delta
		if MapTimeCounter>6:
			mapmode=false
			get_node("../Camera2D").current = false
			get_node("../player").ToggleCamera(true)
			get_node("../player").map_mode = false
			get_node("../CanvasLayer/UI").ui_visible(true)
			GameInstance.paused = false
	if !GameInstance.paused:
		if timer<1:
			timer+=delta
		else:
			GameInstance.time-=1
			var perc = GameInstance.time/GameInstance.MAXTIME*100
			get_node("../CanvasLayer/UI").update_time(perc)
			timer=0
			if GameInstance.time<=0:
				#game over
				if GameInstance.old_mode:	#if old school mode active, remove saved game
					GameInstance.delete_game()
					
				get_tree().change_scene("res://Scenes/Defeat.tscn")
				#invalidate saved game


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_Back_pressed()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_Back_pressed()


func _on_Back_pressed():
	GameInstance.paused = true			
	get_node("../CanvasLayer").add_child(PauseMenuScene.instance())
	
func display_map():
	if !mapmode and mapviews<4:
		get_node("../CanvasLayer/UI").ui_visible(false)
		mapmode=true
		mapviews+=1
		MapTimeCounter = 0
		get_node("../player").ToggleCamera(false)
		get_node("../player").map_mode = true
		get_node("../Camera2D").current = true
		get_node("../CanvasModulate").visible = false
		GameInstance.paused = true
	else:
		get_node("../Camera2D").current = false
		get_node("../CanvasModulate").visible = true
		get_node("../player").ToggleCamera(true)
		get_node("../player").map_mode = false
		get_node("../CanvasLayer/UI").ui_visible(true)
		mapmode = false
		GameInstance.paused = false


func _on_limit_body_entered(body: Node) -> void:
	get_tree().change_scene("res://Scenes/Defeat.tscn")
	

func correct():	
	get_node("../fx").stream = correct_sound
	get_node("../fx").play()

func wrong():
	get_node("../fx").stream = fail_sound
	get_node("../fx").play()



