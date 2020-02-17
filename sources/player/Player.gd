extends KinematicBody2D


class_name Player

signal death

export var Gravity: int = 500
export var  RunMaxSpeed: int = 500
export var  JumpSpeed: int = 200
export var  RunForce: int = 1000
export var StopForce: int = 1000

# player must stand atleast in StandBouncingTime to jump
export var  StandBouncingTime: float = 0.15

var velocity: Vector2 = Vector2()
var jumping: bool = false
var crouching: bool = false

func _ready():
	pass


#func _process(delta):
#	pass

func _physics_process(delta):
	var force = Vector2(0, Gravity)

	var walk = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var jump = Input.is_action_pressed("ui_up")
	var stop = true
	
	if abs(velocity.x) < RunMaxSpeed:
		force.x += RunForce * walk
			
	if stop:
		# slide player
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= StopForce * delta
		if vlen < 0:
			vlen = 0
			
		velocity.x = vlen * vsign
		
	velocity += force * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

	if is_on_floor():
		jumping = false

	if jump and not jumping:
			velocity.y = -JumpSpeed
			jumping = true
