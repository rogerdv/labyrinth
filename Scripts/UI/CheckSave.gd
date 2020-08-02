extends Button


func _ready() -> void:
	var check = File.new()
	if not check.file_exists("user://savedgame"):
		self.visible = false
