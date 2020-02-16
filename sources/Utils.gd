"""
Generic features
"""
extends Node


func change_scene(path: String) -> void:
	"""
	Set the new scene
	"""
	if path == "":
		return

	assert(get_tree().change_scene(path) == OK)
