"""
Handle the game logic
"""
extends Node2D
class_name Game
signal game_start
signal game_end

export (Array, PackedScene) var levels

var level
var level_id: int


func _ready() -> void:
	assert(levels.size() > 0)

	start()


func start() -> void:
	"""
	Game just started
	"""
	level_id = -1
	next()

	emit_signal("game_start")


func load_level(id: int) -> bool:
	"""
	Loads the given level ID
	Game is over when it returns false
	"""
	clean()

	if id >= levels.size():
		return false

	level_id = id
	level = levels[id].instance()
	add_child(level)

	assert(level.connect("level_end", self, "on_level_end") == OK)

	return true


func clean() -> void:
	"""
	Clean the current level
	"""
	if level:
		remove_child(level)
		level.queue_free()


func next() -> void:
	"""
	Loads next level
	"""
	if not load_level(level_id + 1):
		end(true)


func end(won: bool) -> void:
	"""
	When the game is terminated
	"""
	if won:
		# TODO: Goes to credits
		pass

	emit_signal("game_end")


func on_level_end() -> void:
	next()
