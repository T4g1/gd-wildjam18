"""
Plays children audio streams
"""
extends Node2D
class_name MultipleAudioStreamPlayer2D

var streams = []
var timer = 0

export (float) var interval = 0		# Time between two children gets played
export (bool) var loop = false
export (bool) var playing = false


func _ready() -> void:
	randomize()

	# Gather all streams to be played
	for child in get_children():
		assert(child is AudioStreamPlayer2D)
		streams.append(child)

		assert(child.connect("finished", self, "_on_child_finished") == OK)

	if playing:
		play()


func play() -> void:
	"""
	Plays a random children
	"""
	playing = true
	timer = 0

	var stream  = streams[randi() % streams.size()]
	stream.play()


func _process(delta) -> void:
	"""
	Tiemout to play next track
	"""
	if not playing:
		return

	if timer > 0:
		timer -= delta

		if timer <= 0:
			play()


func _on_child_finished() -> void:
	"""
	Starts playback of next random child
	"""
	if loop and playing:
		timer = interval
	else:
		playing = false


func stop() -> void:
	"""
	Ends playback
	"""
	playing = false
	timer = 0

	for stream in streams:
		stream.stop()
