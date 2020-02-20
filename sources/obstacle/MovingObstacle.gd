"""
Handles a trigger that moves along a path
Shall be children of a PathFollow2D
"""
extends Node2D
signal triggered

export(float) var speed = 100
export (bool) var is_moving = false

var follower


func _ready():
	follower = get_parent()
	assert(follower is PathFollow2D)


func _process(delta):
	"""Only move when follower/path is set
	"""
	if is_moving:
		set_offset(follower.offset + speed * delta)


func set_offset(value: float) -> void:
	"""
	Sets where the tornado is on the path
	"""
	follower.offset = value


func get_offset() -> float:
	"""
	Get where the tornado is on the path
	"""
	return follower.offset


func disable() -> void:
	"""Disable moving
	"""
	is_moving = false


func enable() -> void:
	"""Enable moving
	"""
	is_moving = true


func _on_body_entered(body) -> void:
	emit_signal("triggered", body)
