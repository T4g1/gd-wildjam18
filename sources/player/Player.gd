extends KinematicBody2D


class_name Player

signal death

export(float) var Gravity = 500
export(float) var  RunMaxSpeed = 500
export(float) var  JumpSpeed = 200
export(float) var JumpMaxDuration = 0.5
export(float) var  RunForce = 1000
export(float) var StopForce = 1000

var velocity: Vector2 = Vector2()
var jumping: bool = false
var on_air_time: float = 0

func _ready():
	pass


#func _process(delta):
#	pass

func _physics_process(delta):
	var force = Vector2(0, Gravity)

	var walk = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var jump = Input.is_action_pressed("ui_up")
	
	# while jumping, player can't change direction. Can be update later
	if not jumping:
		force.x = update_horizontal_force(walk, delta)
		
	velocity += force * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	try_to_jump(jump, delta)
	on_air_time += delta

	
func update_horizontal_force(walk, delta):
	var horizontal_force = 0

	if abs(velocity.x) < RunMaxSpeed:
		horizontal_force += RunForce * walk
	
	if abs(walk) < 0.5:
		# slide player before stop
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= StopForce * delta
		if vlen < 0:
			vlen = 0
			
		velocity.x = vlen * vsign
		
	return horizontal_force
	
func try_to_jump(jump, delta):
	var falling = false

	if is_on_floor():
		on_air_time = 0
		jumping = false
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping.
		falling = true

	if on_air_time < JumpMaxDuration and jump and not falling:
		velocity.y = -JumpSpeed
		jumping = true
