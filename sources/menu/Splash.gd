extends Control

onready var tween := $Tween as Tween
onready var logo := $Logo
onready var topic := $Topic

# warning-ignore:unused_class_variable
var delay := 0.0

var animate_state


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		load_title()


func _ready() -> void:
	VisualServer.set_default_clear_color(Color("#0d1e29"))

	logo.modulate.a = 0
	topic.modulate.a = 0

	animate()


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

	# Wait one second
	__ = tween.interpolate_property(self, "delay", 0, 1, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 8)

	__ = tween.start()
	yield(tween, "tween_all_completed")


func load_title() -> void:
	"""
	Goes to the title screen specified
	"""
	var __ = tween.stop_all()

	Utils.main_menu()
