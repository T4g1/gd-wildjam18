"""
Handle credits scene
"""
extends Node2D


func _ready() -> void:
	"""
	Start credits animation
	"""
	VisualServer.set_default_clear_color(Color.black)
	
	$AnimationPlayer.play("lightning")

	yield($AnimationPlayer, "animation_finished")

	$AnimationPlayer.play("credits")

	yield($AnimationPlayer, "animation_finished")

	$AnimationPlayer.play("staff")

	yield($AnimationPlayer, "animation_finished")

	Utils.game_completed = true
	Utils.main_menu()


