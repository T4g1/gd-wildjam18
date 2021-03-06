"""
Specific logic for the level Apartment
"""
extends "res://sources/level/Level.gd"

export (PackedScene) var puzzle_scene


func _ready() -> void:
	assert(puzzle_scene)

	assert($Fridge.connect("interacted", self, "on_fridge_interacted") == OK)
	assert($TV.connect("interacted", self, "on_tv_interacted") == OK)
	assert($Window.connect("interacted", self, "on_window_interacted") == OK)
	assert($Drawer.connect("interacted", self, "on_drawer_interacted") == OK)
	assert($FrontDoor.connect("interacted", self, "on_front_door_interacted") == OK)

	$UI/Mask.visible = true

	introduction()


func introduction() -> void:
	"""
	Level start hidden with a dialog
	When dialogs end, level fade in and player can start playing
	"""

	yield(start_dialog($UI/Introduction), "completed")

	$Tween.interpolate_property($UI/Mask, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	yield($Tween, "tween_all_completed")


func on_fridge_interacted(_actor: Node2D) -> void:
	"""
	Player gets food and wants to eat it in front of TV
	"""
	$Fridge.interactable = false
	$TV.interactable = true

	yield(start_dialog($UI/FoodGrabbed), "completed")


func on_tv_interacted(_actor: Node2D) -> void:
	"""
	Player notice TV is broken, fixes it and then want to see incoming
	danger through window
	"""

	yield(start_dialog($UI/TVBroken), "completed")

	var puzzle = Utils.get_game().puzzle_start(puzzle_scene)
	assert(puzzle.connect("puzzle_won", self, "on_puzzle_won") == OK)


func on_window_interacted(_actor: Node2D) -> void:
	"""
	Player notice incoming plague, wants to grab his keys before fleeing
	"""
	$Window.interactable = false
	$Drawer.interactable = true

	yield(start_dialog($UI/WindowLook), "completed")


func on_drawer_interacted(_actor: Node2D) -> void:
	"""
	Player gets keys, now want to flee to save his family
	"""
	$Drawer.interactable = false
	$FrontDoor.interactable = true

	yield(start_dialog($UI/KeyGot), "completed")


func on_front_door_interacted(_actor: Node2D) -> void:
	"""
	End of level 1
	"""
	end()


func on_puzzle_won() -> void:
	"""
	TV is fixed when puzzle is won
	"""
	$TV.interactable = false
	$Window.interactable = true

	Utils.get_game().puzzle_quit()

	play_plague_warning()


func play_plague_warning() -> void:
	"""
	Inform player about plague incoming
	"""
	yield(start_dialog($UI/PlagueInfo), "completed")
