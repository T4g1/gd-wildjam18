"""
Specific logic for the level where player open the shelter

In this level player must open steel door solving a short puzzle
"""
extends "res://sources/level/Level.gd"


func _ready():
	assert($SteelDoor.connect("interacted", self, "on_door_interacted") == OK)
	assert($Generator.connect("interacted", self, "on_generator_interacted") == OK)
	assert($Keypad.connect("interacted", self, "on_keypad_interacted") == OK)
	assert($Board.connect("interacted", self, "on_board_interacted") == OK)

	VisualServer.set_default_clear_color(Color.black)

	introduction()


func introduction() -> void:
	yield(start_dialog($UI/Introduction), "completed")


func on_door_interacted(_body) -> void:
	pass


func on_generator_interacted(_body) -> void:
	pass


func on_keypad_interacted(_body) -> void:
	pass


func on_board_interacted(_body) -> void:
	pass
