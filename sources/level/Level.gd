"""
Handle one level logic
"""
extends Node2D
class_name Level
signal level_start
signal level_end


func start() -> void:
	"""
	Called when the level starts
	"""
	emit_signal("level_start")


func end() -> void:
	"""
	Called when player reach end of the level
	"""
	emit_signal("level_end")
