"""
Puzzle where player has to repeat the pattenr from Boardinfo
"""
extends "res://sources/Puzzle.gd"


func _input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()

	if event.is_action_pressed("ui_cancel"):
		quit()
