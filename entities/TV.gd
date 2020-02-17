"""
Logic of the TV
"""
extends "res://sources/entity/Interactable.gd"

export (PackedScene) var puzzle_scene


func _ready() -> void:
	assert(puzzle_scene)


func on_interacted(_actor: Node2D) -> void:
	var puzzle = Utils.get_game().puzzle_start(puzzle_scene)

	assert(puzzle.connect("puzzle_won", self, "puzzle_won") == OK)


func on_range_entered(_actor: Node2D) -> void:
	modulate.r = 0
	modulate.g = 0


func on_range_exited(_actor: Node2D) -> void:
	modulate.r = 1
	modulate.g = 1


func puzzle_won() -> void:
	"""
	Called if player succeed in the puzzle
	"""
	# TODO

	Utils.get_game().puzzle_quit()
