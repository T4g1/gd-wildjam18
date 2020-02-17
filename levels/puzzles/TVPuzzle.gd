"""
Handles logic for the first puzzle
Puzzle state is represented by two coordinates:
	Position of the antenna on the X axis
	Selected channel on the Y axis
"""
extends Node2D
signal puzzle_quit
signal puzzle_won

const MIN_VALUE = 0
const MAX_VALUE = 4

export (int, 0, 4) var initial_antenna = 0
export (int, 0, 4) var initial_channel = 0
export (int) var max_win_streak = 4

var state = Vector2(0, 0)
var correct_move = Vector2(0, 0)
var win_streak = 0
var clues


func _ready() -> void:
	clues = [
		$Clues/BottomClue,
		$Clues/TopClue,
		$Clues/RighClue,
		$Clues/LeftClue
	]

	reset()


func reset() -> void:
	"""
	Reset puzzle
	"""
	randomize()

	state.x = initial_antenna
	state.y = initial_channel

	generate_clue()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		emit_signal("puzzle_quit")

	var guess = Vector2(0, 0)
	if event.is_action_pressed("ui_down"):
		guess = Vector2(0, -1)
	if event.is_action_pressed("ui_up"):
		guess = Vector2(0, 1)
	if event.is_action_pressed("ui_right"):
		guess = Vector2(1, 0)
	if event.is_action_pressed("ui_left"):
		guess = Vector2(-1, 0)

	if guess.length() > 0:
		yield(move(guess), "completed")


func move(guess: Vector2) -> void:
	"""
	Move the current state of the puzzle
	"""
	if guess == correct_move:
		yield(right_guess(), "completed")
	else:
		yield(wrong_guess(), "completed")

	state += guess
	state.x = int(state.x) % MAX_VALUE
	state.y = int(state.y) % MAX_VALUE

	if has_won():
		print("you won")
		emit_signal("puzzle_won")
	else:
		generate_clue()


func generate_clue() -> void:
	"""
	Generate next visual clue
	"""
	hide_clues()

	var moves = [
		Vector2( 0, -1),
		Vector2( 0,  1),
		Vector2( 1,  0),
		Vector2(-1,  0)
	]

	assert(clues.size() == moves.size())

	var id = randi() % moves.size()

	correct_move = moves[id]
	show_clue(clues[id])


func hide_clues() -> void:
	"""
	Hide all clues
	"""
	for clue in clues:
		clue.visible = false


func show_clue(clue: Node2D) -> void:
	"""
	Show a visual clue to the player
	"""
	clue.visible = true


func has_won() -> bool:
	return win_streak >= max_win_streak


func wrong_guess() -> void:
	"""
	Animation showing the player is wrong
	"""
	# TODO
	yield(get_tree(), "idle_frame")
	win_streak = 0

	print("wrong guess")


func right_guess() -> void:
	"""
	Animation showing the player is correct
	"""
	# TODO
	yield(get_tree(), "idle_frame")
	win_streak += 1

	print("correct guess")
