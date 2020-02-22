"""
Handles logic for the first puzzle
Puzzle state is represented by two coordinates:
	Position of the antenna on the X axis
	Selected channel on the Y axis
"""
extends Node2D
signal puzzle_quit
signal puzzle_won

const LEFT =  Vector2(-1,  0)
const RIGHT = Vector2( 1,  0)
const UP =    Vector2( 0, -1)
const DOWN =  Vector2( 0,  1)

var accept_inputs = true
var moves = [
	DOWN,
	UP,
	RIGHT,
	LEFT,
]


func quit() -> void:
	emit_signal("puzzle_quit")


func won() -> void:
	emit_signal("puzzle_won")


func _ready() -> void:
	randomize()

	reset()


func reset() -> void:
	"""
	Reset puzzle
	"""
	pass


func animate_press(button: AnimatedSprite) -> void:
	"""
	Animate the press on a button
	"""
	button.play("pressed")
	yield(button, "animation_finished")
	button.play("default")


func has_won() -> bool:
	"""
	Override me
	"""
	return false


func wrong_guess() -> void:
	"""
	Animation showing the player is wrong
	Override me
	"""
	yield(get_tree(), "idle_frame")


func right_guess() -> void:
	"""
	Animation showing the player is correct
	Override me
	"""
	yield(get_tree(), "idle_frame")


