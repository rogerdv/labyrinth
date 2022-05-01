extends Control

const JOYSTICK_RIGHT_X = 750
const JOYSTICK_Y = 385
const BUTTONS_LEFT_X = 30


func _ready() -> void:
	if not OS.has_touchscreen_ui_hint():
		$Sprite.visible=false
	else:
		if GameInstance.invert_control:
			$Sprite.position.x = JOYSTICK_RIGHT_X
			$Fire.position.x = BUTTONS_LEFT_X
			$Map.position.x  = BUTTONS_LEFT_X

func update_time(percent):
	$MarginContainer/Cont/MarginContainer/progress.value = percent

func set_score(score):
	$MarginContainer/Cont/Score.text = String(score)

func set_keys(keys):
	$MarginContainer/Cont/keys.text = String(keys)
	
func set_bombs(bombs):
	$MarginContainer/Cont/bombs.text = String(bombs)
	
func _on_Map_pressed() -> void:
	get_node("../../SceneInfo").display_map()

func ui_visible(toggle:bool):
	$Fire.visible = toggle
	$Map.visible = toggle
	$MarginContainer/Cont.visible = toggle
	if OS.has_touchscreen_ui_hint():
		$Sprite.visible = toggle

func _on_Fire_pressed() -> void:
	get_node("../../player").FireBomb()
	
func get_joystick():
	if OS.has_touchscreen_ui_hint():
		return $Sprite/TouchScreenButton
