extends CanvasLayer

class_name PauseMenu

signal pause
signal resume
signal go_to_main_menu

onready var pause_button = $PauseButton
onready var resume_popup = $ResumePopup
onready var resume_button = $ResumePopup/ResumeButton
onready var go_to_menu_button = $ResumePopup/GotoMenuButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_button.connect("button_down", self, "on_pause")
	resume_button.connect("button_down", self, "on_resume")
	go_to_menu_button.connect("button_down", self, "on_go_to_menu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# TODO: consider to handle show/hide logic inside this class only.
# Show there's no mistake when show/hide popup in wrong context
func show_popup() -> void:
	"""Expose API to show pop up
	"""
	resume_popup.show()
	
func hide_popup() -> void:
	"""Expose API to hide pop up
	"""
	resume_popup.hide()

func on_pause() -> void:
	emit_signal("pause")
	show_popup()

func on_resume() -> void:
	emit_signal("resume")
	hide_popup()

func on_go_to_menu() -> void:
	emit_signal("go_to_main_menu")
	hide_popup()
