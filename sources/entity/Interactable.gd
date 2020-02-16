"""
Handles any entity the player can interact with
"""
extends Node2D
class_name Interactable
signal range_entered	# Emited when an actor is in range and can interract
signal range_exited		# Actor left interaction range
signal interacted		# When this is interacted with


export (NodePath) var interaction_range


func _ready() -> void:
	# Connect signals of the area used for interaction range
	var area = get_node(interaction_range)

	assert(area)
	assert(area.connect("body_entered", self, "_on_range_entered") == OK)
	assert(area.connect("body_exited", self, "_on_range_exited") == OK)


func on_interacted(_actor: Node2D) -> void:
	"""
	Called when actor interacts with this
	Override to define behavior
	"""
	pass


func on_range_entered(_actor: Node2D) -> void:
	"""
	Called when something that can interact with this is in range
	Override to define behavior
	"""
	pass


func on_range_exited(_actor: Node2D) -> void:
	"""
	Called when something that can interact with this
	leave the interaction range
	Override to define behavior
	"""
	pass


func interact(actor: Node2D):
	"""
	Called when something interact with this
	"""
	emit_signal("interacted", actor)

	on_interacted(actor)


func _on_range_entered(body: Node2D) -> void:
	emit_signal("range_entered", body)

	on_range_entered(body)


func _on_range_exited(body: Node2D) -> void:
	emit_signal("range_exited", body)

	on_range_exited(body)
