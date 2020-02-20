"""
State of a Finite State Machine
"""
extends Node

# warning-ignore:unused_class_variable
var fsm = null


func _ready():
	disable()


func enable():
	"""
	Enable logic processing
	"""
	set_process(true)
	set_process_input(true)
	set_process_unhandled_input(true)
	set_physics_process(true)


func disable():
	"""
	Disable logic processing
	"""
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_physics_process(false)


func on_enter():
	enable()

	enter()


func on_exit():
	disable()

	exit()


func enter():
	"""
	Override to define what happens when the state becomes active
	"""
	pass


func exit():
	"""
	Override to define what happens when the state is no longer active
	"""
	pass
