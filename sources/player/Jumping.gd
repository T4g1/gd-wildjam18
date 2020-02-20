extends "res://sources/State.gd"

var air_time


func enter():
	air_time = 0


func _physics_process(delta) -> void:
	air_time += delta

	owner.velocity.y = -owner.jump_force

	# End of jump when key is released or when too long in the air
	if air_time >= owner.jump_duration or not Input.is_action_pressed("ui_up"):
		fsm.set_state("falling")
