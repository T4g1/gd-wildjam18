extends "res://sources/State.gd"

func enter():
	owner.wall_direction = owner.direction.x


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		fsm.set_state("bouncing")


func _physics_process(_delta) -> void:
	if owner.is_on_floor():
		fsm.set_state("idle")
		return

	elif not owner.is_on_wall():
		fsm.set_state("falling")
		return

	owner.velocity.y = owner.sliding_speed
