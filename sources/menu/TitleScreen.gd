"""
Handle logic in title screen
"""
extends Control

export (String, FILE, "*.tscn,*.scn") var game_path


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	Utils.change_scene(game_path)
