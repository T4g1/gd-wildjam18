"""
Logic when player is idle
"""
extends "res://sources/State.gd"


func _physics_process(_delta) -> void:
	if owner.is_falling():
		fsm.set_state("falling")
		return


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		fsm.set_state("jumping")
		return
