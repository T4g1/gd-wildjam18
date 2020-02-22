"""
Handles player logic
"""
extends KinematicBody2D
class_name Player
signal interact

export (Vector2) var max_speed = Vector2(150, 150)
export (float) var jump_force = 250
export (float) var jump_duration = 0.3
export (float) var bounce_duration = 0.3
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

var wall_direction: int = 0			# Where was wall last hit

var sfx_playing = null


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

	speed.x = clamp(speed.x, 0, max_speed.x)

	velocity.x = speed.x * direction.x
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)
	speed.x = abs(velocity.x)

	update_animation()


func play_sfx(sfx_name: String) -> void:
	"""
	Plays a SFX
	"""
	if sfx_playing and sfx_playing.name == sfx_name:
		return

	stop_sfx()

	sfx_playing = $SFX.get_node(sfx_name)
	sfx_playing.play()


func stop_sfx() -> void:
	"""
	Stops SFX from playing
	"""
	if sfx_playing:
		sfx_playing.stop()
		sfx_playing = null


func play_animation(animation_name: String) -> void:
	"""
	Play the given animation
	"""
	$Sprite.play(animation_name)


func update_animation() -> void:
	"""
	Update player animation direction on velocity
	"""
	if velocity.x != 0:
		$Sprite.flip_h = velocity.x < 0


func disable() -> void:
	"""
	Disable player interactions
	"""
	set_physics_process(false)
	set_process_unhandled_input(false)

	stop()

	$States.disable()


func enable() -> void:
	"""
	Enable player interactions
	"""
	set_physics_process(true)
	set_process_unhandled_input(true)

	$States.enable()


func is_falling() -> bool:
	"""
	Check if player is falling
	"""
	return velocity.y > 0


func is_on_wall() -> bool:
	"""
	Check if the player is very close to a wall
	is_on_wall from KinematicBody2D is unreliable as it gets detected only
	if player move in direction of the wall during that frame
	This one works standing next to a wall too
	"""
	return $WallDetector.get_overlapping_bodies().size() > 0


func stop() -> void:
	"""
	Stops player from moving
	"""
	$States.set_state("idle")

	speed = Vector2(0, 0)
	direction = Vector2(0, 0)
	input_direction = Vector2(0, 0)
	velocity = Vector2(0, 0)
