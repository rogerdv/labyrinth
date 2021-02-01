extends Control


func _ready() -> void:
	if not OS.has_touchscreen_ui_hint():
		$Sprite.visible=false

func update_time(percent):
	$Cont/MarginContainer/progress.value = percent

func set_score(score):
	$Cont/Score.text = String(score)

func set_keys(keys):
	$Cont/keys.text = String(keys)
	
func set_bombs(bombs):
	$Cont/bombs.text = String(bombs)
	
func _on_Map_pressed() -> void:
	get_node("../../SceneInfo").display_map()

func ui_visible(toggle:bool):
	$Fire.visible = toggle
	$Map.visible = toggle
	$Cont.visible = toggle
	if OS.has_touchscreen_ui_hint():
		$Sprite.visible = toggle

func _on_Fire_pressed() -> void:
	get_node("../../player").FireBomb()
	
func get_joystick():
	if OS.has_touchscreen_ui_hint():
		return $Sprite/TouchScreenButton
