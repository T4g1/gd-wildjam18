extends Control

onready var tween := $Tween as Tween
onready var logo := $Logo
onready var topic := $Topic

export (String, FILE, "*.tscn,*.scn") var title_screen_path


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		load_title()


func _ready() -> void:
	logo.modulate.a = 0
	topic.modulate.a = 0

	animate()


func animate() -> void:
	"""
	Does some animations before showing the title screen
	"""
	yield(get_tree().create_timer(1), "timeout")

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

	if title_screen_path == "":
		return

	__ = get_tree().change_scene("res://source/menu/TitleScreen.tscn")
