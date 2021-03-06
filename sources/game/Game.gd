"""
Handle the game logic
"""
extends Node2D
class_name Game
signal game_start
signal game_end

export (Array, PackedScene) var levels
export (int) var level_id = -1

var level

var puzzle = null		# Stores any ongoing puzzle scene


func _ready() -> void:
	assert(levels.size() > 0)

	# Allows us to keep the gray background in the editor
	VisualServer.set_default_clear_color(Color.black)

	start()


func start() -> void:
	"""
	Game just started
	"""
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
		Utils.credits()

	emit_signal("game_end")


func on_level_end() -> void:
	next()


func puzzle_start(scene: PackedScene) -> Node2D:
	"""
	Player enters a puzzle scene
	"""
	Utils.get_player().disable()

	puzzle = scene.instance()
	add_child(puzzle)

	assert(puzzle.connect("puzzle_quit", self, "puzzle_quit") == OK)

	return puzzle


func puzzle_quit() -> void:
	"""
	Player leave the puzzle screen
	"""
	Utils.get_player().enable()

	if not puzzle:
		return

	remove_child(puzzle)
	puzzle.queue_free()

	puzzle = null


func _input(event: InputEvent) -> void:
	"""
	Allows to pause game
	"""
	if event.is_action_pressed("ui_cancel"):
		$UI/PauseMenu.on_pause()


func get_active_spawn() -> Node:
	"""
	Get where player should spawn
	"""
	for spawn in get_tree().get_nodes_in_group("spawn"):
		if spawn.is_active():
			return spawn

	# Should always have an active spawn!
	assert(false)
	return null
