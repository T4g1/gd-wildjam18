"""
Spawn point where player can respawn
"""
extends Area2D
signal spawn_left
signal spawn_entered

export (bool) var activated = false
export (bool) var trigger_once = true

var trigger_count = 0
var triggered = false


func _ready():
	return
	if activated:
		activate()
	else:
		deactivate()


func activate() -> void:
	"""
	Deactivate all other spawn and set this one active
	"""
	for spawn in get_tree().get_nodes_in_group("spawn"):
		spawn.deactivate()

	activated = true

	modulate.r = 1
	modulate.g = 1


func deactivate() -> void:
	"""
	Deactivate this spawn point
	"""
	activated = false

	modulate.r = 0
	modulate.g = 0


func _on_body_entered(_body) -> void:
	trigger_count += 1

	triggered = true
	emit_signal("spawn_entered", self)

	if trigger_once and trigger_count > 1:
		return

	activate()


func _on_body_exited(_body) -> void:
	if not triggered:
		return

	triggered = false
	emit_signal("spawn_left", self)


func is_active():
	return activated
