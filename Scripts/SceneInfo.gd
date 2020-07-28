extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export(String) var NextLevel
var SceneScore: int =0
var Start:Vector2
var timer:float = 0
var mapviews:int = 0
var mapmode:bool = false

# Called when the node enters the scene tree for the first time.
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
			GameInstance.SaveGame()
			get_tree().change_scene("res://Scenes/main_menu.tscn")
		elif event.scancode == KEY_SPACE:
			get_node("../player").FireBomb()
			
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameInstance.paused:
		if timer<1:
			timer+=delta
		else:
			GameInstance.time-=1
			var perc = GameInstance.time/120*100
			get_node("../CanvasLayer/InfoBar/Cont/progress").value = perc
			timer=0

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_Back_pressed()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_Back_pressed()

func _on_Back_pressed():
	GameInstance.SaveGame()
	get_tree().change_scene("res://Scenes/main_menu.tscn")
	
