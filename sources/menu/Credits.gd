"""
Handle credits scene
"""
extends Node2D


func _ready() -> void:
	"""
	Start credits animation
	"""
	yield(get_tree().create_timer(1), "timeout")

	$Sprite.play("die")

	yield($Sprite, "animation_finished")

	$AnimationPlayer.play("credits")

	yield($AnimationPlayer, "animation_finished")

	Utils.main_menu()


