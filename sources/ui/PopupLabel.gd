"""
Handle a label appearing on top of something
"""
tool
extends Control
class_name PopupLabel

export (float) var floating_distance = 5
export (float) var speed = 0.3
export (Color) var color = Color("FFFFFF")
export (String) var text = ""
export (Texture) var icon_texture = null

var start_position


func _ready() -> void:
	if Engine.editor_hint:
		$Label.text = text
		return

	start_position = rect_global_position

	hide()


func display() -> void:
	display_text(text)


func display_text(content: String) -> void:
	"""
	Shows the label
	"""
	$Label.modulate = color
	$Label.text = content

	$Icon.texture = icon_texture

	_animate()


func hide() -> void:
	"""
	Hide the label
	"""
	$Tween.stop_all()
	modulate.a = 0


func _animate():
	# Scale from nothing to normal scale
	$Tween.interpolate_property(self, "rect_scale",
		Vector2(0, 0), Vector2(1, 1), speed,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)

	# Move up slowly
	$Tween.interpolate_property(self, "rect_global_position:y",
		start_position.y,
		start_position.y - floating_distance,
		speed,
		Tween.TRANS_SINE, Tween.EASE_IN
	)

	# Appear progressively
	$Tween.interpolate_property(self, "modulate:a",
		0, 1, speed,
		Tween.TRANS_SINE, Tween.EASE_IN
	)

	$Tween.start()
