"""
Handles the speech bubble of a specific character
"""
extends Control
class_name SpeechBubble
signal bubble_start		# Start displaying
signal bubble_next		# Show next line
signal bubble_end		# Nothing more to say


onready var nametag := $Name/Margin/Label as Label
onready var label := $Content/Margin/Label as Label


func say(content: String, who: String="") -> void:
	"""
	Text said out loud by the character
	"""
	# TODO: Different style?
	start(content, who)


func think(content: String, who: String="") -> void:
	"""
	Thought of a character
	"""
	# TODO: Different style?
	start(content, who)


func start(content: String, who: String="") -> void:
	"""
	Displays the given text
	"""
	show_name(who)

	label.text = content
	label.lines_skipped = 0

	visible = true

	emit_signal("bubble_start")


func show_name(who: String) -> void:
	"""
	Displays who's talking
	"""
	if who != "":
		$Name.visible = true
		nametag.text = who
	else:
		$Name.visible = false


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
