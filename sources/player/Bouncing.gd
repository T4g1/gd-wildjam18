extends "res://sources/State.gd"

var bounce_time


func enter():
	bounce_time = 0

	owner.play_animation("jump")


func _physics_process(delta) -> void:
	bounce_time += delta

	owner.speed.x = owner.max_speed.x
	owner.input_direction.x = -owner.wall_direction

	owner.velocity.y = -owner.jump_force

	if bounce_time >= owner.bounce_duration:
		fsm.set_state("falling")
