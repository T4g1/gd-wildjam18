"""
Handle credits scene
"""
extends Node2D


func _ready() -> void:
	"""
	Start credits animation
	"""
	$AnimationPlayer.play("lightning")

	yield($Sprite, "animation_finished")

	$AnimationPlayer.play("credits")

	yield($AnimationPlayer, "animation_finished")

	Utils.game_completed = true
	Utils.main_menu()


