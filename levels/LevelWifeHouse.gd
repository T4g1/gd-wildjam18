"""
Specific logic for the level Ex-Wife's house
"""
extends "res://sources/level/Level.gd"


func _ready() -> void:
	assert($Car.connect("interacted", self, "on_car_interacted") == OK)
	assert($GasCan.connect("interacted", self, "on_gas_interacted") == OK)
	assert($Tires.connect("interacted", self, "on_tires_interacted") == OK)
	assert($Tools.connect("interacted", self, "on_tools_interacted") == OK)

	introduction()


func introduction() -> void:
	"""
	Level start hidden with a dialog
	When dialogs end, level fade in and player can start playing
	"""

	yield(start_dialog($UI/Introduction), "completed")
	yield(start_dialog($UI/BritanyPanic), "completed")
	yield(start_dialog($UI/BilyStuck), "completed")
	yield(start_dialog($UI/GotCrowbar), "completed")
	yield(start_dialog($UI/BilySaved), "completed")
	yield(start_dialog($UI/GotTires), "completed")
	yield(start_dialog($UI/GotGas), "completed")
	yield(start_dialog($UI/EverythingReady), "completed")


func on_car_interacted(__) -> void:
	pass


func on_gas_interacted(__) -> void:
	pass


func on_tires_interacted(__) -> void:
	pass


func on_tools_interacted(__) -> void:
	pass
