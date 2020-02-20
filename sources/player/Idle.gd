"""
Logic when player is idle
"""
extends "res://sources/State.gd"


func _physics_process(_delta) -> void:
	if owner.is_falling():
		fsm.set_state("falling")
		return

	if owner.velocity.x != 0:
		owner.play_animation("run")
	else:
		owner.play_animation("idle")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		fsm.set_state("jumping")
		return
