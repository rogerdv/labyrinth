extends Control


var count = 0
var bonus = 0
var stop:bool = false


func _ready() -> void:
	GameInstance.KeysUsed += GameInstance.SceneKeysUsed
	GameInstance.BombsUsed += GameInstance.SceneBombsUsed
	GameInstance.GhostsKilled += GameInstance.SceneGhostsKilled
	$TextureProgress.value = GameInstance.time / GameInstance.MAXTIME * 100	


func _process(delta: float) -> void:
	if !stop:
		count += delta
		if count > 0.1:
			$AudioStreamPlayer.play()
			GameInstance.time -= 2
			if GameInstance.time <= 0:
				stop = true
				GameInstance.time = 0
			GameInstance.score += 4
			count = 0
			$HBoxContainer/val.text = String(GameInstance.score)
			var perc = GameInstance.time/GameInstance.MAXTIME*100
			$TextureProgress.value = perc
			


func _on_Button_pressed() -> void:
	#load next scene
	if stop:
		get_tree().change_scene(GameInstance.NextScene)
