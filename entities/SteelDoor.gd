extends "res://sources/entity/Interactable.gd"


func open():
	$Sprite.play("open")


func close():
	$Sprite.play("closed")
