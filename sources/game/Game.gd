"""
Handle the game logic
"""
extends Node2D
class_name Game
signal game_start
signal game_end

export (Array, PackedScene) var levels
export (String, FILE, "*.tscn,*.scn") var credits_path
export (PackedScene) var GUI

var level
var level_id: int

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
	
	# create gui and add to level
	var gui = GUI.instance()
	# TODO: set related properties for settings if need

	assert(level.connect("level_end", self, "on_level_end") == OK)

	assert(gui.connect("pause", self, "on_pause") == OK)
	assert(gui.connect("resume", self, "on_resume") == OK)

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


"""Handle GUI events
"""
func on_pause() -> void:
	if level:
		level.get_tree().paused = true
		# TODO: show resume popup
	pass
	
func on_resume() -> void:
	if level:
		level.get_tree().paused = true
		# TODO: hide resume popup
	pass
