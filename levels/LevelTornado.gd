"""
Specific logic for the action level tornado
"""
extends "res://sources/level/Level.gd"

onready var tornado = $TornadoPath/TornadoFollow/Tornado


func _ready():
	for spawn in get_tree().get_nodes_in_group("spawn"):
		assert(spawn.connect("spawn_left", self, "_on_spawn_left") == OK)

	assert($EndTrigger.connect("range_entered", self, "_on_end") == OK)

	VisualServer.set_default_clear_color(Color("#b6d3e1"))

	introduction()


func introduction() -> void:
	yield(start_dialog($UI/Introduction), "completed")


func _on_spawn_left(spawn) -> void:
	"""
	Enable the tornado when player leaves spawn
	"""
	if spawn == Utils.get_game().get_active_spawn():
		tornado.enable()


func _on_Tornado_triggered(_body) -> void:
	"""
	Respawn player and move tornado back before player spawn
	"""
	var spawn = Utils.get_game().get_active_spawn()
	$Player.position = spawn.global_position

	yield(get_tree(), "idle_frame")

	tornado.set_offset(spawn.get_parent().offset)
	tornado.disable()


func _on_Tornado_end_reached(__=null) -> void:
	end()


func _on_end(_body) -> void:
	end()


func end() -> void:
	yield(get_tree(), "idle_frame")

	.end()
