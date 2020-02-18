"""
Handle a label appearing on top of something
"""
extends Control
class_name PopupLabel

export (float) var floating_distance = 5
export (float) var speed = 0.3
export (Color) var color = Color("FFFFFF")
export (Texture) var icon_texture = null

onready var label := $Label
onready var tween := $Tween
onready var icon := $Icon

var start_position


func _ready() -> void:
	start_position = rect_global_position

	hide()


func display(content: String) -> void:
	"""
	Shows the label
	"""
	label.modulate = color
	label.text = content

	icon.texture = icon_texture

	_animate()


func hide() -> void:
	"""
	Hide the label
	"""
	tween.stop_all()
	modulate.a = 0


func _animate():
	# Scale from nothing to normal scale
	tween.interpolate_property(self, "rect_scale",
		Vector2(0, 0), Vector2(1, 1), speed,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)

	# Move up slowly
	tween.interpolate_property(self, "rect_global_position:y",
		start_position.y,
		start_position.y - floating_distance,
		speed,
		Tween.TRANS_SINE, Tween.EASE_IN
	)

	# Appear progressively
	tween.interpolate_property(self, "modulate:a",
		0, 1, speed,
		Tween.TRANS_SINE, Tween.EASE_IN
	)

	tween.start()
