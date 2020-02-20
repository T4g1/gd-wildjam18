extends "res://sources/obstacle/Obstacle.gd"

export(float, 200) var speed = 100

var follower: PathFollow2D
var is_moving: bool = false


func _process(delta):
	if is_moving and follower:
		follower.offset += speed * delta


func attach_to_path(path: Path2D):
	follower = PathFollow2D.new()
	follower.loop = false
	follower.add_child(self)
	path.add_child(follower)

func disable() -> void:
	"""Disable moving
	"""
	is_moving = false
	
func enable() -> void:
	"""Enable moving
	"""
	is_moving = true
