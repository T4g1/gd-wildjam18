"""
Logic of the TV
"""
extends "res://sources/entity/Interactable.gd"

export (bool) var fixed = false


func on_range_entered(_actor: Node2D) -> void:
	$PopupLabel.display("Watch TV")


func on_range_exited(_actor: Node2D) -> void:
	$PopupLabel.hide()
