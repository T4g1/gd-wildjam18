"""
Specific logic for the action level tornado
"""
extends "res://sources/level/Level.gd"

onready var tornado = $TornadoPath/TornadoFollow/Tornado


func _ready():
	for spawn in get_tree().get_nodes_in_group("spawn"):
		assert(spawn.connect("spawn_left", self, "_on_spawn_left") == OK)


func _on_spawn_left():
	"""
	Enable the tornado when player leaves spawn
	"""
	tornado.enable()


func _on_Tornado_triggered(_body) -> void:
	"""
	Respawn player and move tornado back before player spawn
	"""
	var spawn = Utils.get_game().get_active_spawn()
	$Player.position = spawn.global_position
	tornado.set_offset(spawn.get_parent().offset)
	tornado.disable()
