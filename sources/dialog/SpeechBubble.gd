"""
Handles the speech bubble of a specific character
"""
extends Control
class_name SpeechBubble
signal bubble_start		# Start displaying
signal bubble_next		# Show next line
signal bubble_end		# Nothing more to say


onready var label := $PanelContainer/Content as Label


func say(content: String) -> void:
	"""
	Text said out loud by the character
	"""
	# TODO: Different style?
	start(content)


func think(content: String) -> void:
	"""
	Thought of a character
	"""
	# TODO: Different style?
	start(content)


func start(content: String) -> void:
	"""
	Displays the given text
	"""
	label.text = content
	label.lines_skipped = 0

	visible = true

	emit_signal("bubble_start")


func next() -> void:
	"""
	Displays the next lines
	"""
	var line_shown = label.lines_skipped + label.max_lines_visible
	if line_shown < label.get_line_count():
		label.lines_skipped += label.max_lines_visible
		emit_signal("bubble_next")
	else:
		end()


func end() -> void:
	"""
	Bubble is hidden
	"""
	visible = false
	emit_signal("bubble_end")


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_accept"):
		next()
