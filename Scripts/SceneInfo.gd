extends Node


export(String) var NextLevel
var SceneScore: int =0
var Start:Vector2
var timer:float = 0
var mapviews:int = 0
var mapmode:bool = false
var PauseMenuScene = preload("res://UI/PauseMenu.tscn")

func _ready() -> void:
	Start = get_node("../player").position
	GameInstance.time = 120
	GameInstance.SceneScore = 0
	GameInstance.SceneBombsUsed = 0
	GameInstance.SceneKeysUsed = 0
	GameInstance.SceneGhostsKilled = 0


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_M:
			if !mapmode and mapviews<3:
				mapviews+=1
				get_node("../player").ToggleCamera(false)
				get_node("../Camera2D").current = true
			else:
				get_node("../Camera2D").current = false
				get_node("../player").ToggleCamera(true)
				mapmode = false
		elif event.scancode == KEY_F5:
			GameInstance.SaveGame()
		elif 	event.scancode == KEY_F6:
			GameInstance.LoadGame()
		elif event.scancode == KEY_ESCAPE:
			GameInstance.paused = true			
			get_node("../CanvasLayer").add_child(PauseMenuScene.instance())
		#elif event.scancode == KEY_SPACE:
		#	get_node("../player").FireBomb()


func _process(delta: float) -> void:
	if !GameInstance.paused:
		if timer<1:
			timer+=delta
		else:
			GameInstance.time-=1
			var perc = GameInstance.time/120*100
			get_node("../CanvasLayer/UI").update_time(perc)
			timer=0
			if GameInstance.time<=0:
				#game over
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
