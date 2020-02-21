"""
Plays children audio streams
"""
extends Node2D
class_name MultipleAudioStreamPlayer2D

var streams = []

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
	print("run start")
	playing = true

	var stream  = streams[randi() % streams.size()]
	stream.play()


func _on_child_finished() -> void:
	"""
	Starts playback of next random child
	"""
	if loop:
		yield(get_tree().create_timer(interval), "timeout")

		if playing:
			play()
	else:
		playing = false


func stop() -> void:
	"""
	Ends playback
	"""
	print("run stop")
	playing = false

	for stream in streams:
		stream.stop()
