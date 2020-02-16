extends KinematicBody2D


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
	
	if run_left:
		if velocity.x > -RunMaxSpeed:
			current_run_force.x -= RunForce
			stop = false
		else:
			print('Reached max speed when run left')
	elif run_right:
		if velocity.x < RunMaxSpeed:
			current_run_force.x += RunForce
			stop = false
		else:
			print('Reached max speed when run right')
			
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
		print('Crouch')
		crouching = true
		stand_time = 0
		$AnimationPlayer.play("Crouch")

	if jump:
		if crouching:
			if can_stand:
				print('Stand')
				$AnimationPlayer.play("Standup")
				crouching = false
				stand_time += delta
			else:
				print('Can not stand in pipe')
		elif not jumping and stand_time > StandBouncingTime:
			print('Jump')
			velocity.y = -JumpSpeed
			jumping = true
		elif stand_time < StandBouncingTime:
			# just stand after crouch, need more time to stand before jump
			print('Stand time: ', stand_time)
			stand_time += delta


func _on_StandShape_body_shape_entered(body_id, body, body_shape, area_shape):
	# TODO check if collide with world instead of other part
	stand_shape_collide_time += 1
	can_stand = false
	print('Enter stand shape: ', stand_shape_collide_time)


func _on_StandShape_body_shape_exited(body_id, body, body_shape, area_shape):
	# TODO check if collide with world instead of other part
	stand_shape_collide_time -= 1
	if stand_shape_collide_time == 0:
		can_stand = true
	print('Exit stand shape: ', stand_shape_collide_time)


func _on_DeathHole_body_shape_entered(body_id, body, body_shape, area_shape):
	print('You death')
	emit_signal("death")
