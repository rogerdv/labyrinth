extends Node


var easy
var ghost
var lang = "en"
var score:int = 0
var keys:int = 0
var bombs:int = 0
var KeysUsed:int = 0
var BombsUsed:int = 0
var GhostsKilled:int = 0

#Config params
var old_mode: bool = false
var invert_control = false
var conf_name = "user://labyrinth.conf"

#scene temp values
var SceneScore:int = 0
var SceneKeysUsed:int = 0
var SceneBombsUsed:int = 0
var SceneGhostsKilled:int = 0
var time:float

var paused:bool = false
var error
var PrevEasy = []
var PrevGhost = []
var NextScene

const MAXTIME = 150

var sound_fx:AudioStreamPlayer2D

var token=""
var premium=false

func _ready() -> void:
	get_tree().set_quit_on_go_back(false)
	
	_detect_os_locate()
	
	read_conf()

	_read_easy_question_db_by_lang(lang)
	_read_ghost_question_db_by_lang(lang)

	randomize()	


func SaveGame():
	var savefile = File.new()
	
	savefile.open("user://savedgame", File.WRITE)
	
	#print("name of scene to save: ", get_tree().current_scene.filename)
	
	savefile.store_pascal_string(get_tree().current_scene.filename)
	savefile.store_32(score)
	savefile.store_32(KeysUsed)
	savefile.store_32(BombsUsed)
	savefile.store_32(GhostsKilled)
	#if GameInstance.old_mode:
	#	savefile.store_32(1)
	#else:
	#	savefile.store_32(0)
	savefile.close()


func LoadGame():
	var savedfile = File.new()
	
	if not savedfile.file_exists("user://savedgame"):
		#print("error: you don't have a saved game!")
		return # Error! We don't have a save to load.
		
	savedfile.open("user://savedgame", File.READ)
	
	var scene = savedfile.get_pascal_string()
	
	score = savedfile.get_32()
	KeysUsed  = savedfile.get_32()
	BombsUsed  = savedfile.get_32()
	GhostsKilled = savedfile.get_32()
	#var mode = savedfile.get_32()
	#if mode==1:
	#	GameInstance.old_mode = true
	#else:
	#	GameInstance.old_mode = false
		
	savedfile.close()
	get_tree().change_scene(scene)

func delete_game():
	var dir = Directory.new()
	if dir.file_exists("user://savedgame"):
		dir.remove("user://savedgame")
	

func get_easy_rand_question():
	# generate a random question id
	var idx = randi() % easy.size()

	# check if question was recently displayed
	while PrevEasy.has(idx):
		idx = randi() % easy.size()

	# clean previous easy question stack
	_manage_easy_stack(idx)
	
	# shuffle choises
	return _shuffle_question_choices(easy[idx])


func get_ghost_rand_question():
	# generate a random question id
	var idx = randi() % ghost.size()
	
	# check if question was recently displayed
	while PrevGhost.has(idx):
		idx = randi() % ghost.size()

	# clean previous ghost question stack
	_manage_ghost_stack(idx)
	
	# shuffle choises
	return _shuffle_question_choices(ghost[idx])


# Private


func _detect_os_locate():
	if OS.get_locale().begins_with("es"): 
		lang = "es"


func _read_easy_question_db_by_lang(lang):
	var file = File.new()
	file.open("res://QuestionsDB/easy-" + lang + ".json", File.READ)
	
	var json_result = JSON.parse(file.get_as_text())
	easy = json_result.result
	print(easy.size())
	error = json_result.error
	
	file.close()


func _read_ghost_question_db_by_lang(lang):
	var file = File.new()
	file.open("res://QuestionsDB/ghost-" + lang + ".json", File.READ)
	
	var json_result = JSON.parse(file.get_as_text())
	ghost = json_result.result
	error = json_result.error
	print(ghost.size())
	file.close()


func _manage_easy_stack(idx : int):
	if PrevEasy.size() == 65:
		PrevEasy.remove(0)
		PrevEasy.append(idx)
	else:
		PrevEasy.append(idx)


func _manage_ghost_stack(idx : int):
	if PrevGhost.size() == 40:
		PrevGhost.remove(0)
		PrevGhost.append(idx)
	else:
		PrevGhost.append(idx)


func _shuffle_question_choices(question):
	var choices = question.choices
	
	choices.shuffle()
	question.choices = choices
	
	return question

func read_conf():
	var config = File.new()
	if not config.file_exists(conf_name):
		old_mode = false
		invert_control = false
		premium = false
		token=""
		save_conf()
	else:
		var temp
		config.open(conf_name, File.READ)
		
		temp = config.get_16()
		if temp == 1:
			old_mode = true
		else:
			old_mode = false
		
		temp = config.get_16()
		if temp == 1:
			invert_control = true
		else:
			invert_control = false
		temp = config.get_16()
		if temp==1:
			premium=true
		else:
			premium=false
		token = config.get_pascal_string()


func save_conf():
	var config = File.new()
	config.open(conf_name, File.WRITE)
	if old_mode:
		config.store_16(1)
	else:
		config.store_16(0)
	if invert_control:
		config.store_16(1)
	else:
		config.store_16(0)
	if premium:
		config.store_16(1)
	else:
		config.store_16(0)
	config.store_pascal_string(token)
