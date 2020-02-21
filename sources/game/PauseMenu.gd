extends CanvasLayer

class_name PauseMenu

signal pause
signal resume
signal go_to_main_menu

onready var pause_button = $MarginContainer/PauseButton
onready var resume_popup = $ResumePopup
onready var resume_button = $ResumePopup/MarginContainer/VBoxContainer/ResumeButton
onready var go_to_menu_button = $ResumePopup/MarginContainer/VBoxContainer/GotoMenuButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_button.connect("pressed", self, "on_pause")
	resume_button.connect("pressed", self, "on_resume")
	go_to_menu_button.connect("pressed", self, "on_go_to_menu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _show_popup() -> void:
	"""Private API to show pop up
	"""
	resume_popup.show()
	
func _hide_popup() -> void:
	"""Private API to hide pop up
	"""
	resume_popup.hide()

func on_pause() -> void:
	emit_signal("pause")
	_show_popup()

func on_resume() -> void:
	_hide_popup()
	emit_signal("resume")

func on_go_to_menu() -> void:
	emit_signal("go_to_main_menu")
	_hide_popup()
