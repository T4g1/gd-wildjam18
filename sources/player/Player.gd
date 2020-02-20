"""
Handles player logic
"""
extends KinematicBody2D
class_name Player
signal interact

export (Vector2) var max_speed = Vector2(150, 150)
export (float) var jump_force = 200
export (float) var jump_duration = 0.3
export (float) var sliding_speed = 5
export (float) var acceleration = 9
export (float) var deceleration = 7

var speed: Vector2 = Vector2()		# Absolute speed of the player
var velocity: Vector2 = Vector2()	# Velocity applied to the player
var jumping: bool = false
var air_time: float = 0
var gravity

var input_direction: Vector2 = Vector2()
var direction: Vector2 = Vector2()


func _ready() -> void:
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		emit_signal("interact", self)

	# Jumping
	if event.is_action_pressed("ui_up") and is_on_floor():
		jumping = true
	if event.is_action_released("ui_up"):
		jumping = false


func _physics_process(delta) -> void:
	"""
	Handles player movements
	"""

	# Inputs
	if input_direction.length():
		direction = input_direction

	input_direction = Vector2(0, 0)
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1

	# Movement
	if input_direction.x == - direction.x:
		speed.x = 0
	if input_direction.x:
		speed.x += acceleration
	else:
		speed.x -= deceleration

	# Jumping
	if jumping:
		air_time += delta

		# End of the jump
		var falling = velocity.y > 0
		if air_time >= jump_duration or falling:
			jumping = false
		else:
			velocity.y = -jump_force
	else:
		air_time = 0

	speed.x = clamp(speed.x, 0, max_speed.x)

	velocity.x = speed.x * direction.x
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)
	speed.x = abs(velocity.x)

	var sliding = not is_on_floor() and is_on_wall()
	if sliding and not jumping:
		velocity.y = sliding_speed

	update_animation()


func update_animation() -> void:
	"""
	Update player animation based on velocity
	"""
	if velocity.x != 0:
		$Sprite.play("run")

		$Sprite.flip_h = velocity.x < 0
	else:
		$Sprite.play("idle")


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
