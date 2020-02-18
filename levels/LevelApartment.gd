"""
Specific logic for the level Apartment
"""
extends "res://sources/level/Level.gd"

export (PackedScene) var puzzle_scene


func _ready() -> void:
	assert(puzzle_scene)

	assert($TV.connect("interacted", self, "on_tv_interacted") == OK)


func on_tv_interacted(_actor: Node2D) -> void:
	if $TV.fixed:
		play_tsunami_warning()
	else:
		var puzzle = Utils.get_game().puzzle_start(puzzle_scene)
		assert(puzzle.connect("puzzle_won", self, "on_puzzle_won") == OK)


func on_puzzle_won() -> void:
	"""
	TV is fixed when puzzle is won
	"""
	$TV.fixed = true

	Utils.get_game().puzzle_quit()

	play_tsunami_warning()


func play_tsunami_warning() -> void:
	"""
	Inform player about tsunami incoming
	"""
	# TODO: Tsunami dialog
	pass
