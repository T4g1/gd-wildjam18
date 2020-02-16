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


func cancel_yield(function_state: GDScriptFunctionState) -> void:
	"""
	Force a pending yield to finish
	"""
	while function_state is GDScriptFunctionState:
		function_state = function_state.resume()
