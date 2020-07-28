extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var easy
var ghost
var score:int = 0
var keys:int = 0
var bombs:int = 0
var KeysUsed:int = 0
var BombsUsed:int = 0
var GhostsKilled:int = 0
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().set_quit_on_go_back(false)
	var qfile = File.new()	
	if OS.get_locale().begins_with("es"):		
		qfile.open("res://QuestionsDB/easy-es.json", File.READ)
		var Json = JSON.parse(qfile.get_as_text())
		error = Json.error

		easy = Json.result
		qfile.close()
		qfile.open("res://QuestionsDB/ghost-es.json", File.READ)
		Json  = JSON.parse(qfile.get_as_text())
		ghost = Json.result
		qfile.close()
	else:
		qfile.open("res://QuestionsDB/easy-en.json", File.READ)
		var Json = JSON.parse(qfile.get_as_text())
		error = Json.error
		easy = Json.result
		qfile.close()
		qfile.open("res://QuestionsDB/ghost-en.json", File.READ)
		Json  = JSON.parse(qfile.get_as_text())
		ghost = Json.result
		qfile.close()
	randomize()
	
func SaveGame():	
	var savefile = File.new()
	savefile.open("user://savedgame", File.WRITE)
	print(get_tree().current_scene.filename)
	savefile.store_string(get_tree().current_scene.filename)
	savefile.store_32(score)
	savefile.store_32(KeysUsed)
	savefile.store_32(BombsUsed)
	savefile.store_32(GhostsKilled)
		
func LoadGame():
	var savefile = File.new()
	if not savefile.file_exists("user://savedgame"):
		return # Error! We don't have a save to load.
	savefile.open("user://savedgame", File.READ)
	var scene = savefile.get_line()
	score = savefile.get_32()
	KeysUsed  = savefile.get_32()
	BombsUsed  = savefile.get_32()
	GhostsKilled = savefile.get_32()
	get_tree().change_scene(scene)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
