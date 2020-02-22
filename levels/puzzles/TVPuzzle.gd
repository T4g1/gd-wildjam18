"""
Handles logic for the first puzzle
Puzzle state is represented by two coordinates:
	Position of the antenna on the X axis
	Selected channel on the Y axis
"""
extends "res://sources/Puzzle.gd"
const MIN_VALUE = 0
const MAX_VALUE = 4

export (int, 0, 4) var initial_antenna = 0
export (int, 0, 4) var initial_channel = 0
export (int) var max_win_streak = 4
export (float) var size_factor = 0.2

var state = Vector2(0, 0)
var correct_move = Vector2(0, 0)
var win_streak = 0

# Same order as "moves": Clues matching every moves
onready var clues = [
	$Clues/BottomClue,
	$Clues/TopClue,
	$Clues/RighClue,
	$Clues/LeftClue
]

onready var sfx_channels = [
	$SFX/Channel1,
	$SFX/Channel2,
	$SFX/Channel3
]

onready var sfx_antennas = [
	$SFX/Antenna1,
	$SFX/Antenna2,
	$SFX/Antenna3
]


func reset() -> void:
	state.x = initial_antenna
	state.y = initial_channel

	generate_clue()


func _input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()

	if not accept_inputs:
		return

	if event.is_action_pressed("ui_cancel"):
		quit()

	var guess = Vector2(0, 0)
	var button
	if event.is_action_pressed("ui_down"):
		button = $Channel/Down
		guess = DOWN
	if event.is_action_pressed("ui_up"):
		button = $Channel/Up
		guess = UP
	if event.is_action_pressed("ui_right"):
		button = $Antenna/Right
		guess = RIGHT
	if event.is_action_pressed("ui_left"):
		button = $Antenna/Left
		guess = LEFT

	if guess.length() > 0:
		accept_inputs = false

		animate_press(button)
		play(guess)


func animate_press(button: AnimatedSprite) -> void:
	"""
	Animate the press on a button
	"""
	button.play("pressed")
	yield(button, "animation_finished")
	button.play("default")


func play(guess: Vector2) -> void:
	"""
	Try a possible move
	"""
	var sfx
	if guess.y != 0:
		sfx = sfx_channels[randi() % sfx_channels.size()]
	else:
		sfx = sfx_antennas[randi() % sfx_antennas.size()]

	sfx.play()
	yield(sfx, "finished")

	if guess == correct_move:
		yield(right_guess(), "completed")
	else:
		yield(wrong_guess(), "completed")

	if has_won():
		won()
	else:
		generate_clue()

	accept_inputs = true


func generate_clue() -> void:
	"""
	Generate next visual clue
	"""
	hide_clues()

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
	clue.scale = Vector2(1, 1) + Vector2(size_factor, size_factor) * win_streak


func has_won() -> bool:
	return win_streak >= max_win_streak


func wrong_guess() -> void:
	"""
	Animation showing the player is wrong
	"""
	$SFX/Error.play()
	yield(get_tree(), "idle_frame")

	win_streak = 0


func right_guess() -> void:
	"""
	Animation showing the player is correct
	"""
	$SFX/Correct.play()
	yield(get_tree(), "idle_frame")

	win_streak += 1
