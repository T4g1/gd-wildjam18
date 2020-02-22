"""
Specific logic for the level where player open the shelter

In this level player must open steel door solving a short puzzle
"""
extends "res://sources/level/Level.gd"

export (PackedScene) var board_scene
export (PackedScene) var keypad_scene


func _ready():
	assert(board_scene)
	assert(keypad_scene)

	assert($SteelDoor.connect("interacted", self, "on_door_interacted") == OK)
	assert($Generator.connect("interacted", self, "on_generator_interacted") == OK)
	assert($Keypad.connect("interacted", self, "on_keypad_interacted") == OK)
	assert($Board.connect("interacted", self, "on_board_interacted") == OK)

	VisualServer.set_default_clear_color(Color.black)

	introduction()


func introduction() -> void:
	$Lights.visible = false

	yield(start_dialog($UI/Introduction), "completed")

	$SteelDoor.enable()


func on_door_interacted(_body) -> void:
	yield(start_dialog($UI/LockedDoor), "completed")

	$SteelDoor.disable()
	$Board.enable()
	$Keypad.enable()


func on_generator_interacted(_body) -> void:
	yield(start_dialog($UI/End), "completed")

	end()


func on_keypad_interacted(_body) -> void:
	var keypad = Utils.get_game().puzzle_start(keypad_scene)
	assert(keypad.connect("puzzle_won", self, "on_door_unlocked") == OK)


func on_board_interacted(_body) -> void:
	var _board = Utils.get_game().puzzle_start(board_scene)


func on_door_unlocked() -> void:
	$Board.disable()
	$Keypad.disable()

	$SteelDoor.open()

	Utils.get_game().puzzle_quit()

	yield(start_dialog($UI/DoorUnlocked), "completed")

	$Player.disable()

	$AnimationPlayer.play("door_openned")
	yield($AnimationPlayer, "animation_finished")

	$SteelDoor.close()
	$Lights.visible = true

	yield(start_dialog($UI/DoorBroken), "completed")

	$Generator.enable()
