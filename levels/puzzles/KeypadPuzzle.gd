"""
Puzzle where player has to repeat the pattenr from Boardinfo
"""
extends "res://sources/Puzzle.gd"

var correct_moves = [
	UP,
	RIGHT,
	DOWN,
	RIGHT
]
var move_id = 0


func _input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()

	if event.is_action_pressed("ui_cancel"):
		quit()

	var guess = Vector2(0, 0)
	var button
	if event.is_action_pressed("ui_down"):
		button = $Down
		guess = DOWN
	if event.is_action_pressed("ui_up"):
		button = $Up
		guess = UP
	if event.is_action_pressed("ui_right"):
		button = $Right
		guess = RIGHT
	if event.is_action_pressed("ui_left"):
		button = $Left
		guess = LEFT

	if guess.length() > 0:
		accept_inputs = false

		animate_press(button)
		play(guess)


func play(guess: Vector2) -> void:
	"""
	Try a possible move
	"""
	if correct_moves[move_id] == guess:
		yield(right_guess(), "completed")
	else:
		yield(wrong_guess(), "completed")

	if has_won():
		won()

	accept_inputs = true


func has_won() -> bool:
	return move_id >= correct_moves.size()


func wrong_guess() -> void:
	"""
	Animation showing the player is wrong
	"""
	yield(get_tree(), "idle_frame")

	move_id = 0


func right_guess() -> void:
	"""
	Animation showing the player is correct
	"""
	yield(get_tree(), "idle_frame")

	move_id += 1

