"""
Handle the game logic
"""
extends Node2D
class_name Game
signal game_start
signal game_end

export (Array, PackedScene) var levels
export (String, FILE, "*.tscn,*.scn") var credits_path
export (PackedScene) var PauseMenu

var level
var level_id: int

var puzzle = null		# Stores any ongoing puzzle scene


func _ready() -> void:
	assert(levels.size() > 0)
	assert(PauseMenu)

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
	
	assert(level.connect("level_end", self, "on_level_end") == OK)
	
	# level is newly created. So we need create new pause menu, too
	var pause_menu = PauseMenu.instance()
	# Connect and handle pause menu signal
	assert(pause_menu.connect("pause", self, "on_pause") == OK)
	assert(pause_menu.connect("resume", self, "on_resume") == OK)
	assert(pause_menu.connect("go_to_main_menu", self, "on_go_to_main_menu") == OK)

	# Add pause menu to levels
	level.add_child(pause_menu)

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


"""Handle pause menu events
"""
func on_pause() -> void:
	get_tree().paused = true
	
func on_resume() -> void:
	get_tree().paused = false

func on_go_to_main_menu() -> void:
	get_tree().paused = false
	Utils.main_menu()
