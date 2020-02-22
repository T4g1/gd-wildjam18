extends "res://sources/level/Level.gd"


func _ready():
	yield(start_dialog($UI/Introduction), "completed")
