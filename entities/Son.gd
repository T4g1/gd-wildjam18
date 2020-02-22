tool
extends "res://sources/entity/Interactable.gd"

export (bool) var stuck = true


func _ready():
	if not stuck:
		saved()


func saved():
	stuck = false
	$Sprite.play("default")
