"""
Handle logic in title screen
"""
extends Node2D

export (String, FILE, "*.tscn,*.scn") var game_path
export (Vector2) var mouse_movement = Vector2(50, 50)


func _ready() -> void:
	$UI/Control/VBoxContainer/PlayButton.grab_focus()

	$Jonhy.visible = false
	$Wife.visible = false
	$Son.visible = false

	if Utils.game_completed:
		$Wife.visible = true
		$Son.visible = true
	else:
		$Jonhy.visible = true


func _process(_delta: float) -> void:
	var size = get_viewport_rect().size
	var mouse_position = get_viewport().get_mouse_position()
	var ratio = mouse_position / size

	ratio.x = clamp(ratio.x, 0, 1) - 0.5
	ratio.y = clamp(ratio.y, 0, 1) - 0.5
	$Camera2D.position =  ratio * mouse_movement


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	Utils.change_scene(game_path)
