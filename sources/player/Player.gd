"""
Handles player logic
"""
extends KinematicBody2D
class_name Player

export (float) var max_speed = 200
export (float) var jump_force = 10
export (float) var jump_duration = 0.3
export (float) var run_force = 10
export (float) var stop_force = 300

var velocity: Vector2 = Vector2()
var jumping: bool = false
var air_time: float = 0
var gravity


func _ready() -> void:
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta) -> void:
	"""
	Handles player movements
	"""

	if jumping:
		air_time += delta

	var movement = Vector2(0, 0)

	# Walking
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1

	# Jumping
	if Input.is_action_pressed("ui_up"):
		var falling = velocity.y > 0

		# Jumps begin
		if is_on_floor():
			jumping = true
			movement.y -= 1

		# Can not jump while falling
		elif falling:
			jumping = false

		# Going further up while jumping
		elif jumping and air_time < jump_duration:
			movement.y -= 1
	else:
		jumping = false
		air_time = 0

	# Natural forces
	velocity += Vector2(0, gravity) * delta

	# Player input
	velocity += movement * Vector2(run_force, jump_force)

	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)

	# Apply friction when player stop moving to come to a stop
	if movement.x == 0:
		var friction = sign(velocity.x) * stop_force * delta
		if abs(friction) <= abs(velocity.x):
			velocity.x -= friction
		else:
			velocity.x = 0

	velocity = move_and_slide(velocity, Vector2.UP)

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
