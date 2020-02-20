extends Node2D
signal triggered

export(float) var speed = 100
export(NodePath) var trajectory_path

var follower: PathFollow2D
var is_moving: bool = false


func _ready():
	assert(trajectory_path)
	assert(get_node(trajectory_path))

	call_deferred("attach_to_trajectory", get_node(trajectory_path))


func _process(delta):
	"""Only move when follower/path is set
	"""
	if is_moving and follower:
		follower.offset += speed * delta


func attach_to_trajectory(trajectory):
	"""Create PathFollow2D and make it follow the path
	"""
	assert(trajectory is Path2D)

	get_parent().remove_child(self)

	follower = PathFollow2D.new()
	follower.loop = false
	follower.add_child(self)

	trajectory.add_child(follower)


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
