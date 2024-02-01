extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	if GameInstance.token=="":
		#there is no token
		$MarginContainer/VBoxContainer/debug.text="Solicitando acceso a la tienda"
		var err = $HTTPRequest.request("https://pay.aam.cu/getToken.php?app=org.vswindmills.labyrinth")
		if err!=OK:
			$PanelContainer/MarginContainer/VBoxContainer/Label.text="Error connectando a la tienda. Verifique la conexión"


func donate_pressed(id:String):	
	if GameInstance.token!="":
		OS.shell_open("https://pay.aam.cu/pay.php?id="+id+"&cli="+GameInstance.token)
	else:
		$MarginContainer/VBoxContainer/debug.text="Esperando autorización de acceso..."

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$MarginContainer/VBoxContainer/debug.text=""
	var temp:String=body.get_string_from_utf8()
	if temp.begins_with("["):
		var json = JSON.parse(temp)
		print(json.result)
		if json.result.size()>0:
			GameInstance.premium=true
			GameInstance.save_conf()
			$MarginContainer/VBoxContainer/debug.text="Donación efectuada. ¡Gracias!"
	else:
		$MarginContainer/VBoxContainer/debug.text="Autorización recibida"
		GameInstance.token=temp
		GameInstance.save_conf()


func _on_Timer_timeout():
	if GameInstance.token!="":
		$HTTPRequest.request("https://pay.aam.cu/get-remain.php?cli="+GameInstance.token)


func _on_close_pressed():
	get_tree().change_scene("res://Scenes/main_menu.tscn")
