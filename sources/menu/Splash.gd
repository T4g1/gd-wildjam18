extends Control

onready var tween := $Tween as Tween
onready var logo := $Logo
onready var topic := $Topic

export (String, FILE, "*.tscn,*.scn") var title_screen_path

var animate_state


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# TODO: Move in Utils as force_complete(function_state)
		while animate_state is GDScriptFunctionState:
			animate_state = animate_state.resume()


func _ready() -> void:
	logo.modulate.a = 0
	topic.modulate.a = 0

	animate_state = animate()


func animate() -> void:
	"""
	Does some animations before showing the title screen
	"""
	# Fade in then out the logo
	var __ = tween.interpolate_property(logo, "modulate:a", 0, 1, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 1)
	__ = tween.interpolate_property(logo, "modulate:a", 1, 0, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 2)

	# Fade in then out the topic of the jam
	__ = tween.interpolate_property(topic, "modulate:a", 0, 1, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 5)
	__ = tween.interpolate_property(topic, "modulate:a", 1, 0, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 7)

	__ = tween.start()
	yield(tween, "tween_all_completed")

	load_title()


func load_title() -> void:
	"""
	Goes to the title screen specified
	"""
	var __ = tween.stop_all()

	Utils.change_scene(title_screen_path)
