extends Node2D


const MOVING_SPEED: int = 300

onready var world = $World
onready var ground = $World/Ground
onready var label = $Label
onready var player = $Player

var started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible = false
	player.connect("death", self, "_on_player_death")
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started:
		ground.position.x += MOVING_SPEED * delta

func start():
	world.global_position = Vector2(0, 0)
	ground.global_position = Vector2(0, 0)
	player.global_position = Vector2(200, 200)
	started = true
	
func _on_player_death():
	print('On player death')
	started = false
	label.visible = true
	yield(get_tree().create_timer(2), "timeout")
	label.visible = false
	start()
