"""
Allows to an intro to loop song
For song that are composed of a non looping first part
followed by a looping part
"""
extends Node2D
class_name ComposedAudioStreamPlayer2D

export (bool) var playing = false
export (AudioStream) var intro
export (AudioStream) var loop


func _ready() -> void:
	assert(intro)
	assert(loop)

	$Intro.stream = intro
	$Loop.stream = loop

	if playing:
		play()
	else:
		stop()


func play() -> void:
	playing = true
	$Intro.play()


func stop() -> void:
	playing = false
	$Intro.stop()
	$Loop.stop()


func on_intro_finished() -> void:
	$Loop.play()
