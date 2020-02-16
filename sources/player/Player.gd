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

var stand_time: float = StandBouncingTime * 2

# number of body enter the stand shape. 
# Use to check if player can stand from crouching or not, for example stand in a pipe
var stand_shape_collide_time: int = 0
var can_stand: bool = true

func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass

func _physics_process(delta):
	var current_run_force = Vector2(0, Gravity)

	var run_left = Input.is_action_pressed("ui_left")
	var run_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up")
	var crouch = Input.is_action_pressed("ui_down")
	var stop = true
	
	if run_left and run_right:
		# if both left and right is pressed, just stop
		pass
	elif run_left:
		if velocity.x > -RunMaxSpeed:
			current_run_force.x -= RunForce
			stop = false
	elif run_right:
		if velocity.x < RunMaxSpeed:
			current_run_force.x += RunForce
			stop = false
			
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= StopForce * delta
		if vlen < 0:
			vlen = 0
			
		velocity.x = vlen * vsign
		
	velocity += current_run_force * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

	if is_on_floor():
		jumping = false


	if crouch and not crouching:
		crouching = true
		stand_time = 0
		$AnimationPlayer.play("Crouch")

	if jump:
		if crouching:
			if can_stand:
				$AnimationPlayer.play("Standup")
				crouching = false
				stand_time += delta
			else:
				print('Can not stand in pipe')
		elif not jumping and stand_time > StandBouncingTime:
			velocity.y = -JumpSpeed
			jumping = true
		elif stand_time < StandBouncingTime:
			# just stand after crouch, need more time to stand before jump
			stand_time += delta


func _on_StandShape_body_entered(body):
	# TODO check if collide with world instead of other part
	assert(body)
	stand_shape_collide_time += 1
	can_stand = false


func _on_StandShape_body_exited(body):
	# TODO check if collide with world instead of other part
	assert(body)
	stand_shape_collide_time -= 1
	if stand_shape_collide_time == 0:
		can_stand = true


func _on_DeathHole_body_entered(body):
	assert(body)
	emit_signal("death")
