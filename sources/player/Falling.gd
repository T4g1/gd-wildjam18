extends "res://sources/State.gd"


func _physics_process(_delta) -> void:
	if owner.is_on_floor():
		fsm.set_state("idle")
		return

	if owner.is_on_wall():
		fsm.set_state("sliding")
		return
