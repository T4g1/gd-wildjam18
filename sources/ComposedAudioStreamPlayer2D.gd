"""
Allows to an intro to loop song
"""
extends Node2D

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