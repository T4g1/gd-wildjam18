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


func force_complete(function_state: GDScriptFunctionState) -> void:
	"""
	Force a pending yield to finish
	"""
	while function_state is GDScriptFunctionState:
		function_state = function_state.resume()


func _get_group_singleton(name : String) -> Node:
	assert(len(get_tree().get_nodes_in_group(name)) == 1)

	return get_tree().get_nodes_in_group(name)[0]


func get_game() -> Node:
	return _get_group_singleton("game")


func get_player() -> Node:
	return _get_group_singleton("player")
