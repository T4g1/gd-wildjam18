extends KinematicBody2D
class_name Player
signal interact

export (float) var speed = 400

var movement = Vector2(0, 0)


func _unhandled_input(event: InputEvent) -> void:
	movement = Vector2(0, 0)
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1

	if event.is_action_pressed("interact"):
		emit_signal("interact", self)


func _physics_process(_delta) -> void:
	var velocity = movement * speed
	velocity = move_and_slide(velocity)


func disable():
	"""
	Disable player interactions
	"""
	set_physics_process(false)
	set_process_unhandled_input(false)


func enable():
	"""
	Enable player interactions
	"""
	set_physics_process(true)
	set_process_unhandled_input(true)
