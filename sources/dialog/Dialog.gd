"""
handle any monolog or dialog between one or multiple entities
"""
extends Control
class_name Dialog
signal dialog_start
signal dialog_next
signal dialog_end

export (NodePath) var bubble_path

var bubble

var lines = []
var current_line = 0


func _ready() -> void:
	bubble = get_node(bubble_path)

	assert(bubble)
	assert(bubble.connect("bubble_end", self, "on_bubble_end") == OK)

	# Get lines
	for child in get_children():
		assert(child is DialogLine)

		lines.append(child)


func start() -> void:
	"""
	Start the dialog
	"""
	visible = true
	current_line = -1

	emit_signal("dialog_start")

	next()


func next() -> void:
	"""
	Display next line of dialog
	"""
	current_line += 1

	if current_line >= lines.size():
		end()
		return

	var next_line = lines[current_line]
	if next_line.thinking:
		bubble.think(next_line.content)
	else:
		bubble.say(next_line.content)

	emit_signal("dialog_next")


func end() -> void:
	"""
	Ends the dialog
	"""
	visible = false

	emit_signal("dialog_end")


func on_bubble_end():
	next()
