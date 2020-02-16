extends KinematicBody2D


const GRAVITY: int = 500
# const RUN_MIN_SPEED: int = 10
const RUN_MAX_SPEED: int = 500
const JUMP_SPEED: int = 200
const RUN_FORCE: int = 1000
const STOP_FORCE: int = 1000
const STAND_BOUNCING_TIME: float = 0.15  # player must stand atleast in STAND_BOUNCING_TIME to jump

var velocity: Vector2 = Vector2()
var jumping: bool = false
var crouching: bool = false

var stand_time: float = STAND_BOUNCING_TIME * 2

func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass

func _physics_process(delta):
	var run_force = Vector2(0, GRAVITY)

	var run_left = Input.is_action_pressed("ui_left")
	var run_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up")
	var crouch = Input.is_action_pressed("ui_down")
	var stop = true
	
	if run_left:
		if velocity.x > -RUN_MAX_SPEED:
			run_force.x -= RUN_FORCE
			stop = false
		else:
			print('Reached max speed when run left')
	elif run_right:
		if velocity.x < RUN_MAX_SPEED:
			run_force.x += RUN_FORCE
			stop = false
		else:
			print('Reached max speed when run right')
			
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
			
		velocity.x = vlen * vsign
		
	velocity += run_force * delta
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
			print('Stand')
			$AnimationPlayer.play("Standup")
			crouching = false
			stand_time += delta
		elif not jumping and stand_time > STAND_BOUNCING_TIME:
			print('Jump')
			velocity.y = -JUMP_SPEED
			jumping = true
		elif stand_time < STAND_BOUNCING_TIME:
			# just stand after crouch, need more time to stand before jump
			print('Stand time: ', stand_time)
			stand_time += delta
