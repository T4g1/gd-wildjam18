"""
Handles logic for a pause menu
"""
extends Control
signal pause
signal resume
signal quit

export (bool) var paused = false


func _ready() -> void:
	if paused:
		activate()
	else:
		deactivate()


func activate() -> void:
	"""
	Game becomes paused
	"""
	paused = true
	visible = true
	get_tree().paused = true
	set_process_input(true)


func deactivate() -> void:
	"""
	No longer paused
	"""
	paused = false
	visible = false
	get_tree().paused = false
	set_process_input(false)


func _input(event: InputEvent) -> void:
	"""
	Allows to unpause game
	"""
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()

		on_resume()


func on_pause() -> void:
	activate()

	emit_signal("pause")


func on_resume() -> void:
	deactivate()

	emit_signal("resume")


func on_quit() -> void:
	deactivate()

	emit_signal("quit")

	Utils.main_menu()
