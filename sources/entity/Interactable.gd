"""
Handles any entity the player can interact with
Every node in "actor" group should fire a "interact" signal that will be catched
by this node
"""
extends Node2D
class_name Interactable
signal range_entered	# Emited when an actor is in range and can interract
signal range_exited		# Actor left interaction range
signal interacted		# When this is interacted with


export (NodePath) var interaction_range
export (bool) var interactable = true setget set_interactable

var actors_in_range = []


func _ready() -> void:
	# Connect signals of the area used for interaction range
	var area = get_node(interaction_range)

	assert(area)
	assert(area.connect("body_entered", self, "_on_range_entered") == OK)
	assert(area.connect("body_exited", self, "_on_range_exited") == OK)

	# Connect signals to detect interaction
	for actor in get_tree().get_nodes_in_group("actor"):
		assert(actor.connect("interact", self, "interact") == OK)


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
	$Label.display()


func on_range_exited(_actor: Node2D) -> void:
	"""
	Called when something that can interact with this
	leave the interaction range
	Override to define behavior
	"""
	$Label.hide()


func interact(actor: Node2D):
	"""
	Called when something interact with this
	"""
	if not actor in actors_in_range or not interactable:
		return

	emit_signal("interacted", actor)

	on_interacted(actor)


func _on_range_entered(body: Node2D) -> void:
	if not body.is_in_group("actor") or not interactable:
		return

	emit_signal("range_entered", body)

	# Actor is now in range
	actors_in_range.append(body)

	on_range_entered(body)


func _on_range_exited(body: Node2D) -> void:
	if not body.is_in_group("actor") or not interactable:
		return

	emit_signal("range_exited", body)

	# No longer in range
	var id = actors_in_range.find(body)
	if id > -1:
		actors_in_range.remove(id)

	on_range_exited(body)


func set_interactable(value: bool) -> void:
	"""
	Override for custom behaviors
	"""
	interactable = value

	if not interactable:
		$Label.hide()
