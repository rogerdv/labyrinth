extends Control

#Transition between scenes
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var count = 0
var bonus = 0
var stop:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	GameInstance.KeysUsed+=GameInstance.SceneKeysUsed
	GameInstance.BombsUsed += GameInstance.SceneBombsUsed
	GameInstance.GhostsKilled += GameInstance.SceneGhostsKilled
	$TextureProgress.value = GameInstance.time/120*100
	#TODO: Save game 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !stop:
		count+=delta
		if count>0.1:
			GameInstance.time-=1
			GameInstance.score+= 2
			count = 0
			$HBoxContainer/val.text = String(GameInstance.score)
			var perc = GameInstance.time/120*100
			$TextureProgress.value = perc
			if GameInstance.time==0:
				stop=true


func _on_Button_pressed() -> void:
	#load next scene
	get_tree().change_scene(GameInstance.NextScene)
