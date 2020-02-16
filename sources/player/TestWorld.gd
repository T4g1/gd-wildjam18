extends Node2D


export var MovingSpeed: int = 300

onready var World = $World
onready var Ground = $World/Ground
onready var Label = $Label
onready var Player = $Player

var started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Label.visible = false
	Player.connect("death", self, "_on_player_death")
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started:
		Ground.position.x += MovingSpeed * delta

func start():
	World.global_position = Vector2(0, 0)
	Ground.global_position = Vector2(0, 0)
	Player.global_position = Vector2(200, 200)
	started = true
	
func _on_player_death():
	print('On player death')
	started = false
	Label.visible = true
	yield(get_tree().create_timer(2), "timeout")
	Label.visible = false
	start()
