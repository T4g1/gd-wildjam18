extends "res://sources/levels/LevelTornado.gd"

onready var tornado = $TornadoPath/TornadoFollow/Tornado


func _ready():
	for spawn in get_tree().get_nodes_in_group("spawn"):
		assert(spawn.connect("spawn_left", self, "_on_spawn_left") == OK)

	yield(start_dialog($UI/Introduction), "completed")


func _on_spawn_left(spawn) -> void:
	"""
	Enable the tornado when player leaves spawn
	"""
	if spawn == Utils.get_game().get_active_spawn():
		tornado.enable()
